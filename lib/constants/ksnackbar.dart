import 'package:flutter/material.dart';

const terrSnackbar = SnackBar(
  content: Text("Add Title"),
  closeIconColor: Colors.white,
  backgroundColor: Colors.red,
  showCloseIcon: true,
);

const derrSnackbar = SnackBar(
  content: Text("Add Description"),
  closeIconColor: Colors.white,
  backgroundColor: Colors.red,
  showCloseIcon: true,
);

const saveSuccessSnackbar = SnackBar(
  content: Text(
    "Note Saved",
    style: TextStyle(color: Colors.black),
  ),
  closeIconColor: Colors.white,
  backgroundColor: Color.fromARGB(255, 28, 153, 32),
  showCloseIcon: true,
);
