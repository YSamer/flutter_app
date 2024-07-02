import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_app/core/localization/my_localization.dart';
import 'package:flutter_app/views/widgets/main_text.dart';

Future<File?> pickImage(
  BuildContext context,
) async {
  File? file;
  final picker = ImagePicker();

  final source = await showDialog<ImageSource>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Center(
        child: MainText.heading(
          tr(context).please_select_image,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, ImageSource.camera),
          child: Row(
            children: [
              const Icon(Icons.camera_alt),
              const SizedBox(width: 5),
              Text(
                tr(context).camera,
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, ImageSource.gallery),
          child: Row(
            children: [
              const Icon(Icons.photo_library),
              const SizedBox(width: 5),
              Text(
                tr(context).photo_gallery,
              ),
            ],
          ),
        ),
      ],
    ),
  );
  if (source != null) {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      file = File(pickedFile.path);
    }
  }

  return file;
}
