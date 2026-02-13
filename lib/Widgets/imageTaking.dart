import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Imagetaking extends StatefulWidget {
  const Imagetaking({required this.setImg, super.key});

  final void Function(File f) setImg;

  @override
  State<Imagetaking> createState() => _ImagetakingState();
}

class _ImagetakingState extends State<Imagetaking> {
  final imgpicker = ImagePicker();

  File? img;

  void _takingImage() async {
    final picking = await imgpicker.pickImage(source: ImageSource.camera);
    if (picking == null) {
      return;
    } else {
      setState(() {
        img = File(picking.path);
        widget.setImg(img!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _takingImage,
      child: img == null
          ? CircleAvatar(backgroundColor: Colors.grey, radius: 30)
          : CircleAvatar(foregroundImage: FileImage(img!), radius: 30),
    );
  }
}
