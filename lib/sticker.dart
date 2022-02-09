// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:stick_it/stick_it.dart';

// ignore: must_be_immutable
class Sticker extends StatefulWidget {
  String id;
  File? imageshow;
  Sticker(this.id, this.imageshow, {Key? key}) : super(key: key);

  @override
  _StickerState createState() => _StickerState();
}

class _StickerState extends State<Sticker> {
  ScreenshotController screenshotController = ScreenshotController();

  StickIt? _stickIt;
  bool showStickerBar = true;
  @override
  Widget build(BuildContext context) {
    _stickIt = StickIt(
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(image: FileImage(widget.imageshow!))),
      ),
      panelHeight: showStickerBar == true ? 100 : 0,
      stickerList: [
        Image.asset(
          'assets/icons8-anubis-48.png',
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ),
        Image.asset(
          'assets/icons8-bt21-shooky-48.png',
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ),
        Image.asset(
          'assets/icons8-fire-48.png',
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ),
        Image.asset(
          'assets/icons8-jake-48.png',
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ),
        Image.asset(
          'assets/icons8-keiji-akaashi-48.png',
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ),
        Image.asset(
          'assets/icons8-mate-48.png',
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ),
        Image.asset(
          'assets/icons8-pagoda-48.png',
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ),
        Image.asset(
          'assets/icons8-spring-48.png',
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ),
        Image.asset(
          'assets/icons8-totoro-48.png',
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ),
        Image.asset(
          'assets/icons8-year-of-dragon-48.png',
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ),
      ],
    );

    Random random = Random();
    int randomNumber = random.nextInt(10000000);

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        title: const Text("Sticker"),
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
      body: Screenshot(
        controller: screenshotController,
        child: Container(
          child: _stickIt,
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: SizedBox(
          height: height * 0.1,
          width: width * 0.2,
          child: FloatingActionButton(
            onPressed: () {
              if (showStickerBar == true) {
                setState(() {
                  showStickerBar = false;
                });
              } else if (showStickerBar == false) {
                setState(() {
                  showStickerBar = true;
                });
              }
            },
            mini: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: SizedBox(
              height: height * 0.01,
              width: width * 0.15,
              child: const Icon(
                Icons.emoji_emotions_outlined,
                size: 40,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Container(
          height: height * 0.08,
          color: Colors.white,
        ),
      ),
    );
  }
}
