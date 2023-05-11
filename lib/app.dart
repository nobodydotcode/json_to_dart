import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:json_to_dart/code_generator.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "JSON to Dart",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.lato().fontFamily,
      ),
      home: const CodeGeneratorScaffold(),
    );
  }
}
