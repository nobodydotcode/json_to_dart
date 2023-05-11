import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

extension BuildContextExt on BuildContext {
  void showErrorDialog(String message) {
    MotionToast.error(
      title: const Text("Error"),
      description: Text(message),
    ).show(this);
  }

  void showSuccessDialog(String message) {
    MotionToast.success(
      title: const Text("Success"),
      description: Text(message),
    ).show(this);
  }
}
