import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key});

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _imageFile;

  Future<void> _takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    if (pickedImage == null) {
      return;
    }

    _imageFile = File(pickedImage.path);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 250,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
        ),
        alignment: Alignment.center,
        child: TextButton.icon(
            onPressed: _takePicture,
            icon: Icon(Icons.camera),
            label: Text('Select Image')));
  }
}
