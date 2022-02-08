// ignore_for_file: unnecessary_import, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_initializing_formals, avoid_print, unused_local_variable, unnecessary_string_interpolations, unused_element, unnecessary_null_comparison, unnecessary_cast, await_only_futures, file_names, prefer_const_constructors, unnecessary_new, unused_field, prefer_final_fields, unnecessary_brace_in_string_interps, unrelated_type_equality_checks, library_prefixes
// ignore_for_file: unused_import
import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
// import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
// ignore: i
import 'package:photogallery/Filterimage.dart';
import 'package:photogallery/addText/texteditor.dart';
import 'package:photogallery/blur.dart';
import 'package:photogallery/editedImage.dart';
import 'package:photogallery/sticker.dart';
import 'package:photogallery/videoprovider.dart';
import 'package:photogallery/viewer.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:photofilters/photofilters.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:image_cropper/image_cropper.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:ext_storage/ext_storage.dart';

// ignore: must_be_immutable
class EditImage extends StatefulWidget {
  String filename;
  String id;
  final String name;
  final String path1;

  EditImage(this.filename, this.id, this.name, this.path1, {Key? key})
      : super(key: key);

  @override
  _EditImageState createState() => _EditImageState();
}

class _EditImageState extends State<EditImage> {
  File? imagepath;
  File? medium;
  File? imageFile;

  File? imageshow;

  @override
  void initState() {
    super.initState();
    imageshow = File(widget.path1);
    // print(imageshow);
  }
  // _openImage() async {
  //   try {
  //     var pickedFile = widget.filename;
  //     if (pickedFile != null) {
  //       // String tempDir = await ExtStorage.getExternalStoragePublicDirectory(
  //       //     ExtStorage.DIRECTORY_DCIM);
  //       // String tempPath = tempDir + '/${widget.name}' + '/${pickedFile}';
  //       imagepath = imageshow!;
  //       // print(tempPath);
  //
  //       imagefile = imagepath;
  //       setState(() {});
  //     } else {
  //       print("No image is selected.");
  //     }
  //   } catch (e) {
  //     print("error while picking file.");
  //   }
  // }

  _cropImage() async {
    // print(imageshow!.path);
    final File? croppedfile = await ImageCropper.cropImage(
        sourcePath: imageshow!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Image Cropper',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));

    if (croppedfile != null) {
      imageFile = croppedfile;
      setState(() {
        imageshow = croppedfile;
      });
    } else {
      print("Image is not cropped.");
    }
  }

  double gap = 0;
  var padding = EdgeInsets.symmetric(horizontal: 10, vertical: 5);
  int _index = 0;


  Future<void> _handleClickMe() async {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text('Are you sure you want to discard the changes?'),
        // content: Text('content'),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text('CANCEL'),
            onPressed: () {
              Navigator.pop(context, true);

            },

          ),
          CupertinoDialogAction(
            child: Text('DISCARD'),
            onPressed: () {
              // Navigator.pop(context, true);
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => ViewerPage()));
            },
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    Random random = new Random();
    int randomNumber = random.nextInt(10000000);
    return DefaultTabController(
      initialIndex: 1,
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.close),
            // onPressed: () {},
            onPressed: _handleClickMe,
          ),
          title: Text(widget.filename),
          // leading: IconButton(
          //   icon: const Icon(Icons.close , size: 28, color: Colors.white,),
          //   onPressed: () {
          //     showDialog(
          //         context: context,
          //         builder: (context) {
          //           return AlertDialog(
          //             title: const Text('Are you sure, you want to discard edit?'),
          //             actions: [
          //               TextButton(
          //                   onPressed: () {
          //                     Navigator.pop(context);
          //                   },
          //                   child: const Text(
          //                     'CANCEL',
          //                     style: TextStyle(
          //                         color: Colors.white
          //                     ),
          //                   )
          //               ),
          //               TextButton(
          //
          //                   onPressed: () {
          //                     Navigator.of(context).popUntil((route) => route.isFirst);
          //                     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ViewerPage(medium! , widget.name)));
          //                     // Navigator.pop(context, true);
          //                   },
          //                   child: const Text(
          //                     'DISCARD',
          //                     style: TextStyle(
          //                         color: Colors.white
          //                     ),
          //                   )
          //               )
          //             ],
          //           );
          //         }
          //     );
          //   },
          // ),
          actions: <Widget>[
            imagepath != ""
                ? IconButton(
                    icon: Icon(Icons.save_alt),
                    onPressed: () async {
                      Uint8List bytes = await imageshow!.readAsBytes();
                      var result = await ImageGallerySaver.saveImage(bytes,
                          quality: 60, name: "IMG_${randomNumber}.jpg");
                      print(result);
                      if (result["isSuccess"] == true) {
                        // print("Image saved successfully.");
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) =>EditedImage(imageshow : imageshow)));

                        Navigator.pop(context, imageshow);
                      } else {
                        print(result["errorMessage"]);
                      }
                    },
                  )
                : Container(),
          ],
        ),
        body: Center(
            child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(image: FileImage(imageshow!))),
        )),
        bottomNavigationBar: menu(),
      ),
    );
  }

  Widget menu() {
    return TabBar(
      isScrollable: true,
      tabs: [
        Tab(
          icon: SizedBox(
            child: IconButton(
              padding: const EdgeInsets.all(0.0),
              icon: Column(
                children: const [
                  Icon(Icons.crop),
                  SizedBox(height: 4.0),
                  Text(
                    'Crop',
                    style: TextStyle(
                      fontSize: 8.0,
                    ),
                  )
                ],
              ),
              onPressed: () {
                _cropImage();
              },
            ),
          ),
        ),
        Tab(
          // text: "Filter",
          icon: SizedBox(
            child: IconButton(
              padding: EdgeInsets.all(0.0),
              icon: Column(
                children: const [
                  Icon(Icons.workspaces_outline),
                  SizedBox(height: 4.0),
                  Text(
                    'Filter',
                    style: TextStyle(
                      fontSize: 8.0,
                    ),
                  )
                ],
              ),
              onPressed: () async {
                final result = await Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => FilterImage(widget.id,
                            widget.name, widget.filename, imageshow!)));
                setState(() {
                  imageshow = result;
                });
              },
            ),
          ),
        ),
        Tab(
          // text: "Sticker",
          icon: SizedBox(
            child: IconButton(
              padding: EdgeInsets.all(0.0),
              icon: Column(
                children: const [
                  Icon(Icons.emoji_emotions_outlined),
                  SizedBox(height: 4.0),
                  Text(
                    'Sticker',
                    style: TextStyle(
                      fontSize: 8.0,
                    ),
                  )
                ],
              ),
              onPressed: () async {
                final result = await Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => Sticker(widget.id, imageshow!)));
                setState(() {
                  imageshow = result;
                });
              },
            ),
          ),
        ),
        Tab(
          // text: "Text",
          icon: SizedBox(
            child: IconButton(
              padding: EdgeInsets.all(0.0),
              icon: Column(
                children: const [
                  Icon(Icons.text_fields),
                  SizedBox(height: 4.0),
                  Text(
                    'Text',
                    style: TextStyle(
                      fontSize: 8.0,
                    ),
                  )
                ],
              ),
              onPressed: () async {
                final result = await Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            TextImage(widget.id, imageshow!)));
                setState(() {
                  imageshow = result;
                });
              },
            ),
          ),
        ),
        Tab(
          // text: "Blur",
          icon: SizedBox(
            child: IconButton(
              padding: EdgeInsets.all(0.0),
              icon: Column(
                children: const [
                  Icon(Icons.blur_on),
                  SizedBox(height: 4.0),
                  Text(
                    'Blur',
                    style: TextStyle(
                      fontSize: 8.0,
                    ),
                  )
                ],
              ),
              onPressed: () async {
                final result = await Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            BlurImage(widget.id, imageshow!)));
                setState(() {
                  imageshow = result;
                });
              },
              // onPressed: () {
              //   Navigator.of(context).push(MaterialPageRoute(
              //       builder: (context) => BlurImage(widget.id)));
              // },
              // onPressed: () {},
            ),
          ),
        ),
        // Tab(
        //   text: "Light Effect",
        //   icon: Icon(Icons.light),
        // ),
        // Tab(
        //   text: "Border",
        //   icon: Icon(Icons.crop_square_sharp),
        // ),
      ],
    );
  }
}
