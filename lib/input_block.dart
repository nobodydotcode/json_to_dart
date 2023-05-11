import 'package:flutter/material.dart';
import 'package:json_to_dart/utils.dart';

class InputBlock extends StatefulWidget {
  const InputBlock({super.key, required this.onSubmit});

  final void Function(String json, String className) onSubmit;

  @override
  State<InputBlock> createState() => _InputBlockState();
}

class _InputBlockState extends State<InputBlock> {
  late TextEditingController _jsonInputController;
  late TextEditingController _nameController;

  @override
  void initState() {
    _jsonInputController = TextEditingController();
    _nameController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            minLines: 24,
            maxLines: 60,
            controller: _jsonInputController,
            decoration: const InputDecoration(
              hintText: 'Input JSON',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 80,
            width: 250,
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Class Name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_jsonInputController.text.isEmpty) {
                context.showErrorDialog("Please enter valid JSON");
              } else if (_nameController.text.isEmpty) {
                context.showErrorDialog("Please enter class name");
              } else {
                widget.onSubmit(
                    _jsonInputController.text, _nameController.text);
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16.0),
            ),
            child: const Text('SUBMIT'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _jsonInputController.dispose();
    super.dispose();
  }
}
