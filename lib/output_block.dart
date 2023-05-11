import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:json_to_dart/utils.dart';

class OutputBlock extends StatelessWidget {
  const OutputBlock({super.key, required this.output});

  final String output;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 200,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(6.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  output,
                  style: GoogleFonts.sourceCodePro(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: output));
              context.showSuccessDialog("Copied successfully");
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16.0),
            ),
            child: const Text('Copy to clipboard'),
          ),
        ],
      ),
    );
  }
}
