import 'package:flutter/material.dart';

void showError(BuildContext context, {required String message}) {
  final snackBar = SnackBar(
    content: Text(message, style: TextStyle(color: Colors.white)),
    backgroundColor: Colors.red,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showSuccessMsg(BuildContext context, {required String message}) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
