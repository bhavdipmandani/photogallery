// ignore_for_file: file_names, must_be_immutable

import 'dart:io';
import 'package:flutter/material.dart';

class EditedImage extends StatefulWidget {
  File? imageshow;

  EditedImage({Key? key, this.imageshow}) : super(key: key);

  @override
  _EditedImageState createState() => _EditedImageState();
}

class _EditedImageState extends State<EditedImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(image: FileImage(widget.imageshow!))),
    );
  }
}
