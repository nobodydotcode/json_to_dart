import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:json_to_dart/app.dart';
import 'package:json_to_dart/firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}
