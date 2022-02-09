// ignore_for_file: unnecessary_import, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_initializing_formals, unnecessary_string_interpolations, unused_element, unnecessary_null_comparison, unnecessary_cast, await_only_futures, empty_statements, prefer_const_constructors, unnecessary_new, deprecated_member_use, unused_local_variable
// ignore_for_file: unused_import
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'dart:math';

// ignore: import_of_legacy_library_into_null_safe
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:photogallery/Editimage.dart';
import 'package:photogallery/addwallpaper.dart';
import 'package:photogallery/videoprovider.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:transparent_image/transparent_image.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:share_plus/share_plus.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:path_provider/path_provider.dart';
import 'package:image_cropper/image_cropper.dart';


class ViewerPage extends StatefulWidget {
  final Medium? medium;

  final String? name;
  final File? imageshow;

  // ViewerPage(Medium medium, this.name) : medium = medium;

  ViewerPage({Key? key, this.medium, this.name, this.imageshow})
      : super(key: key);

  @override
  State<ViewerPage> createState() => _ViewerPageState();
}

class _ViewerPageState extends State<ViewerPage> {
  // late TransformationController controller;

  TapDownDetails? tapDownDetails;

  Animation<Matrix4>? animation;

  // Medium? get medium => null;

  // @override
  // void initState() {
  //   super.initState();

  //   controller = TransformationController();
  // }

  // @override
  // void dispose() {
  //   controller.dispose();

  //   super.dispose();
  // }

  File? imageview;

  void imageView() async {
    String tempDir = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DCIM);
    String path = (tempDir + '/${widget.name}') + '/${widget.medium!.filename}';

    // final dir = await getTemporaryDirectory();

    // final path =
    //     await File('${dir.path}/${widget.name}/${widget.medium!.filename}');
    // String path = await '$dir/${widget.medium!.filename}';

    setState(() {
      imageview = File(path);
    });
  }

  @override
  void initState() {
    imageView();
    super.initState();
  }

  static String getFileSizeString({required int bytes, int decimals = 0}) {
    const suffixes = ["b", "kb", "mb", "gb", "tb"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }
    deleteFile() async {
    try {
      // final tempDir = await getTemporaryDirectory();
      final tempDir = await getApplicationDocumentsDirectory();

      File path = File(tempDir.path + '/${widget.name}' + '/${widget.medium!.filename}');
      final file = await path;
      file.delete();
    } catch (e) {
      return 0;
    }
  }

  Future<void> _imageDetail() async {
    DateTime? date = widget.medium!.creationDate ?? widget.medium!.modifiedDate;
    var decodedImage = await decodeImageFromList(imageview!.readAsBytesSync());

    String tempDir = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DCIM);
    String path = tempDir + '/${widget.name}' + '/${widget.medium!.filename}';

    return showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text('Image Details'),
        content: Column(
          children: <Widget> [
            Text(
              "File Name :",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '${widget.medium!.filename}\n',
              style: TextStyle(fontSize: 15.0),
            ),
            Text(
              "Time :",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '${date != null ? (date.toLocal().toString()) : null}\n',
              style: TextStyle(fontSize: 15.0),
            ),
            Text(
              "More Details :",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Size: ${decodedImage.width} * ${decodedImage.height}',
              style: TextStyle(fontSize: 15.0),
            ),
            Text(
              'File Size: ${getFileSizeString(bytes: imageview!.lengthSync())}',
              style: TextStyle(fontSize: 15.0),
            ),
            Text(
              'Path: $path',
              style: TextStyle(fontSize: 14.0),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // late TrackingScrollController controller;

    // DateTime? date = widget.medium?.creationDate ?? widget.medium?.modifiedDate;

    var imageName = '${widget.medium!.filename}';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
          ),
          title: Text(imageName),
          // title: date != null ? Text(date.toLocal().toString()) : null,

          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () => _imageDetail(),
            ),
          ],
        ),
        body: Container(
          alignment: Alignment.center,
          child: widget.medium!.mediumType == MediumType.image
              ? GestureDetector(
                  // onDoubleTapDown: (details) => tapDownDetails = details,
                  // onDoubleTap: () {
                  //   final position = tapDownDetails!.localPosition;

                  //   const double scale = 2;
                  //   final x = -position.dx * (scale - 1);
                  //   final y = -position.dy * (scale - 1);
                  //   final zoomed = Matrix4.identity()
                  //     ..translate(x, y)
                  //     ..scale(scale);

                  //   final value = controller.value.isIdentity()
                  //       ? zoomed
                  //       : Matrix4.identity();
                  //   controller.value = value;
                  // },
                  child: InteractiveViewer(
                    // transformationController: controller,
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(image: FileImage(imageview!))),
                    ),
                  ),
                )
              : VideoProvider(
                  mediumId: widget.medium!.id,
                ),
        ),
        bottomNavigationBar: SizedBox(
          height: 60,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white, size: 25.0),
                onPressed: () async {
                  String tempDir =
                      await ExtStorage.getExternalStoragePublicDirectory(
                          ExtStorage.DIRECTORY_DCIM);
                  String path = (tempDir + '/${widget.name}') +
                      '/${widget.medium!.filename}';
                  File(path).writeAsString(imageName);
                  await Share.shareFiles([path]);
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 25.0,
                ),
                onPressed: () async {
                  String tempDir =
                      await ExtStorage.getExternalStoragePublicDirectory(
                          ExtStorage.DIRECTORY_DCIM);
                  String path1 = (tempDir + '/${widget.name}') +
                      '/${widget.medium!.filename}';
                  final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => EditImage(
                              widget.medium!.filename!,
                              widget.medium!.id,
                              widget.name!,
                              path1)));
                  setState(() {
                    imageview = result;
                  });
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 25.0,
                ),
                onPressed: () async {
                  deleteFile();
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.wallpaper,
                  color: Colors.white,
                  size: 25.0,
                ),
                // onPressed: () {
                //   setWallpaper();
                // },
                onPressed: () async {
                  String tempDir =
                  await ExtStorage.getExternalStoragePublicDirectory(
                      ExtStorage.DIRECTORY_DCIM);
                  File path1 = File(tempDir + '/${widget.name}' + '/${widget.medium!.filename}');
                  final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => ImageWallpaper(
                              widget.medium!.filename!,
                              widget.name!,
                              path1)));
                  setState(() {
                    imageview = result;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
