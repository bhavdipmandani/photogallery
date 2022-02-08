// ignore_for_file: unused_import, library_prefixes, must_be_immutable, avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io' as Io;
import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:text_editor/text_editor.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

class TextImage extends StatefulWidget {
  final String id;
  File imageshow;

  TextImage(this.id, this.imageshow, {Key? key}) : super(key: key);

  @override
  _TextImageState createState() => _TextImageState();
}

class _TextImageState extends State<TextImage> {
  File? image;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    File imagetext = widget.imageshow;
    Random random = Random();
    int randomNumber = random.nextInt(10000000);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, imagetext);
          },
        ),
        title: const Text("Add Text"),
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

                // print(file);

                Navigator.pop(context, file);
                // ShowCapturedWidget(context, file);
              }).catchError((onError) {
                print(onError);
              });
            },
          )
        ],
      ),
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Screenshot(
          controller: screenshotController,
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(image: FileImage(widget.imageshow))),
              ),
              const Page(),
            ],
          ),
        ),
      ),
    );
  }
}

class Page extends StatefulWidget {
  const Page({Key? key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {
  Offset offset = Offset.zero;

  final fonts = [
    'OpenSans',
    'Billabong',
    'GrandHotel',
    'Oswald',
    'Quicksand',
    'BeautifulPeople',
    'BeautyMountains',
    'BiteChocolate',
    'BlackberryJam',
    'BunchBlossoms',
    'CinderelaRegular',
    'Countryside',
    'Halimun',
    'LemonJelly',
    'QuiteMagicalRegular',
    'Tomatoes',
    'TropicalAsianDemoRegular',
    'VeganStyle',
  ];
  TextStyle _textStyle = const TextStyle(
    fontSize: 50,
    color: Colors.white,
    fontFamily: 'OpenSans',
  );
  String _text = 'Write Here';
  TextAlign _textAlign = TextAlign.center;

  void _tapHandler(text, textStyle, textAlign) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: const Duration(
        milliseconds: 400,
      ),
      pageBuilder: (_, __, ___) {
        return Container(
          color: Colors.black.withOpacity(0.4),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: TextEditor(
                fonts: fonts,
                text: text,
                textStyle: textStyle,
                textAlingment: textAlign,
                minFontSize: 10,
                onEditCompleted: (style, align, text) {
                  setState(() {
                    _text = text;
                    _textStyle = style;
                    _textAlign = align;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              offset = Offset(
                  offset.dx + details.delta.dx, offset.dy + details.delta.dy);
            });
          },
          onTap: () => _tapHandler(_text, _textStyle, _textAlign),
          child: SizedBox(
            width: 300,
            height: 300,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(_text, textAlign: _textAlign, style: _textStyle),
              ),
            ),
          )),
    );
  }
}
