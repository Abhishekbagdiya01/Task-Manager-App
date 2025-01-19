import 'package:flutter/material.dart';
void snackbarMessenger({required BuildContext context,required String text, bool isError = false}) {
  final snackBar = SnackBar(
    content: Text(text),
    backgroundColor: isError? Colors.red : Colors.blue,
    behavior: SnackBarBehavior.floating,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}