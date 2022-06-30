import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
  print("no image selected");
}

showSnackBar(String content, BuildContext context, bool warning) {
  Color getColor() {
    if (warning) {
      return Colors.redAccent;
    } else {
      return Colors.greenAccent;
    }
  }

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: getColor(),
      content: Text(content)));
}
