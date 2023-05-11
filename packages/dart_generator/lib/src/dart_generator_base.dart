import 'dart:convert';

import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

class InvalidJsonException implements Exception {
  final String message;
  InvalidJsonException(this.message);
}

class DartCodeGenerator {
  String generate(String json, String className) {
    try {
      // TODO(appal): add support for list
      final decoded = jsonDecode(json) as Map<String, dynamic>;
      final generatedClasses = generateClass(decoded, className);

      return generatedClasses.reversed.join("\n");
    } on FormatException catch (e, st) {
      throw InvalidJsonException("Invalid JSON");
    } catch (e, st) {
      Error.throwWithStackTrace(e, st);
    }
  }

  List<String> generateClass(Map<String, dynamic> decoded, String className) {
    List<String> classes = [];
    final rootClass = Class((b) {
      b.name = className;
      b.extend = refer('Equatable');
      b.annotations.add(const CodeExpression(
          Code('JsonSerializable(fieldRename: FieldRename.snake)')));

      final cBuilder = ConstructorBuilder();
      cBuilder.constant = true;

      final fieldNames = [];

      // Fields
      decoded.entries.forEach((element) {
        String fieldValueType = element.value.runtimeType.toString();

        if (fieldValueType == '_JsonMap') {
          final fieldType =
              '${element.key.substring(0, 1).toUpperCase()}${element.key.substring(1)}';

          b.fields.add(Field((b) {
            b.name = element.key;
            b.type = Reference(fieldType);
            b.modifier = FieldModifier.final$;
          }));

          final subJson = element.value as Map<String, dynamic>;
          final subJsonClass = generateClass(subJson, fieldType);
          classes.addAll(subJsonClass);
        } else if (fieldValueType == 'List<dynamic>') {
          String subType = 'dynamic';
          final l = element.value as List<dynamic>;
          final lvType = l.first.runtimeType.toString();
          switch (lvType) {
            case 'int':
              subType = 'int';
              break;
            case 'String':
              subType = 'String';
              break;
            case 'bool':
              subType = 'bool';
              break;
            case 'double':
              subType = 'double';
              break;
            case '_JsonMap':
              subType =
                  '${element.key.substring(0, 1).toUpperCase()}${element.key.substring(1)}';
              break;
            default:
          }
          b.fields.add(Field((b) {
            b.name = element.key;
            b.type = Reference('List<$subType>');
            b.modifier = FieldModifier.final$;
          }));
          if (lvType == '_JsonMap') {
            l.forEach((element) {
              final subJson = element as Map<String, dynamic>;
              final subJsonClass = generateClass(subJson, subType);
              classes.addAll(subJsonClass);
            });
          }
        } else {
          b.fields.add(Field((b) {
            b.name = element.key;
            b.type = Reference(fieldValueType);
            b.modifier = FieldModifier.final$;
          }));
        }

        cBuilder.optionalParameters.add(Parameter((b) {
          b.name = element.key;
          b.named = true;
          b.required = true;
          b.toThis = true;
        }));

        fieldNames.add(element.key);
      });

      // Constructor
      b.constructors.add(cBuilder.build());

      // props getter
      b.methods.add(Method((b) {
        b.name = "props";
        b.returns = refer('List<Object?>');
        b.type = MethodType.getter;
        b.body = Code("return $fieldNames;");
        b.annotations.add(const CodeExpression(Code("override")));
      }));

      b.methods.add(Method((b) {
        b.name = "fromJson";
        b.returns = Reference(className);
        b.requiredParameters.add(Parameter((pb) {
          pb.name = "json";
          pb.type = refer('Map<String, dynamic>');
        }));
        b.static = true;
        b.body = Code("return _\$${className}FromJson(json);");
      }));

      b.methods.add(Method((b) {
        b.name = "toJson";
        b.returns = refer("Map<String, dynamic>");
        b.body = Code("return _\$${className}ToJson(this);");
      }));
    });

    classes.add(toStringClass(rootClass));
    return classes;
  }

  String toStringClass(Class clazz) {
    final emitter = clazz.accept(DartEmitter());
    return DartFormatter(lineEnding: "\n").format('$emitter');
  }
}
