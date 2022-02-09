// import 'dart:async';
// import 'dart:io';

// ignore_for_file: must_be_immutable, avoid_print

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:blur/blur.dart';

class BlurImage extends StatefulWidget {
  final String id;
  File imageshow;

  BlurImage(this.id, this.imageshow, {Key? key}) : super(key: key);

  @override
  _BlurImageState createState() => _BlurImageState();
}

ScreenshotController screenshotController = ScreenshotController();

class _BlurImageState extends State<BlurImage> {
  double blurValue = 0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    Random random = Random();
    int randomNumber = random.nextInt(10000000);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);

            // print(widget.imageshow);
          },
        ),
        title: const Text("Blur Image"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              screenshotController
                  .capture(delay: const Duration(milliseconds: 10))
                  .then((capturedImage) async {
                Uint8List imageInUnit8List = capturedImage!;
                final tempDir = await getTemporaryDirectory();
                final file = await File('${tempDir.path}/IMG_$randomNumber.jpg')
                    .create();
                file.writeAsBytesSync(imageInUnit8List);
                Navigator.pop(context, file);
                // ShowCapturedWidget(context, file);
              }).catchError((onError) {
                print(onError);
              });
            },
          )
        ],
      ),
      body: Column(
        children: [
          Screenshot(
            controller: screenshotController,
            child: Image.file(
              widget.imageshow,
              width: width * 1.0,
              height: height * 0.8,
            ).blurred(
              colorOpacity: 0.0,
              blur: blurValue,
            ),
          ),
          Slider(
            value: blurValue,
            max: 3,
            activeColor: Colors.blue,
            inactiveColor: Colors.black,
            onChanged: (double value) {
              setState(
                () {
                  blurValue = value;
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
