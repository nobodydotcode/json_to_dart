import 'package:dart_generator/dart_generator.dart';

void main() {
  DartCodeGenerator codeGenerator = DartCodeGenerator();

  final testJson = """
    {
      "key1": 1,
      "key2": "value2",
      "key3": 3.5,
      "key4": true
    }""";

  final output = codeGenerator.generate(testJson, "Sample");
  print(output);
}
