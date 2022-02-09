// ignore_for_file: file_names, must_be_immutable, avoid_print

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

import 'filters.dart';

class FilterImage extends StatefulWidget {
  final String id;
  final String filename;
  final String name;
  File imageshow;
  FilterImage(this.id, this.name, this.filename, this.imageshow, {Key? key})
      : super(key: key);

  @override
  _FilterImageState createState() => _FilterImageState();
}

ScreenshotController screenshotController = ScreenshotController();

class _FilterImageState extends State<FilterImage> {
  final GlobalKey _globalKey = GlobalKey();
  final List<List<double>> filters = [
    NORMAL,
    MATRIX1,
    MATRIX2,
    MATRIX3,
    MATRIX4,
    SEPIA_MATRIX,
    GREYSCALE_MATRIX,
    VINTAGE_MATRIX,
    SWEET_MATRIX
  ];

  @override
  Widget build(BuildContext context) {
    Random random = Random();
    int randomNumber = random.nextInt(10000000);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        title: const Text("Filter Iamge"),
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
      body: Center(
        child: Screenshot(
          controller: screenshotController,
          child: RepaintBoundary(
            key: _globalKey,
            child: PageView.builder(
                itemCount: filters.length,
                itemBuilder: (context, index) {
                  return ColorFiltered(
                    colorFilter: ColorFilter.matrix(filters[index]),
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: FileImage(widget.imageshow))),
                    ),
                  );
                }),
          ),
        ),

        // child: Container(
        //   decoration: BoxDecoration(
        //       image: DecorationImage(
        //           image: FileImage(File(widget.path1))
        //       )
        //   ),
        // ),
      ),
    );
  }
}
