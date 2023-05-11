import 'package:dart_generator/dart_generator.dart';
import 'package:flutter/material.dart';
import 'package:json_to_dart/input_block.dart';
import 'package:json_to_dart/output_block.dart';
import 'package:json_to_dart/utils.dart';

class CodeGeneratorScaffold extends StatefulWidget {
  const CodeGeneratorScaffold({super.key});

  @override
  State<CodeGeneratorScaffold> createState() => _CodeGeneratorScaffoldState();
}

class _CodeGeneratorScaffoldState extends State<CodeGeneratorScaffold> {
  String _output = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JSON to Dart Converter'),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MaterialBanner(
              content: ListTile(
                leading: const Icon(Icons.info),
                contentPadding: const EdgeInsets.all(16.0),
                title: RichText(
                  text: const TextSpan(
                    text:
                        'A simple tool to generate dart classes from JSON. This tool is intended for users who use json_serializable and equatable packages. You need to have ',
                    children: [
                      TextSpan(
                          text: 'equatable',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: ' and '),
                      TextSpan(
                          text: 'json_serializable',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                          text:
                              ' as dependencies. After you take the code, make sure to run build runner to generate fromJson and toJson methods'),
                    ],
                  ),
                ),
              ),
              actions: [const SizedBox()],
            ),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: InputBlock(
                      onSubmit: (json, className) async {
                        try {
                          DartCodeGenerator generator = DartCodeGenerator();
                          _output = generator.generate(
                              json, className.replaceAll(" ", ""));
                          setState(() {});
                        } catch (e, st) {
                          context.showErrorDialog(e.toString());
                        }
                      },
                    ),
                  ),
                  const VerticalDivider(),
                  if (_output.isNotEmpty)
                    Expanded(child: OutputBlock(output: _output)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomAppBar(
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Built with Flutter by Sravani Reddy',
            textAlign: TextAlign.end,
          ),
        ),
      ),
    );
  }
}
