import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';

class ImageWallpaper extends StatefulWidget {
  String filename;
  String name;
  File path1;

  ImageWallpaper(this.filename, this.name, this.path1, {Key? key}) : super(key: key);

  @override
  _ImageWallpaperState createState() => _ImageWallpaperState();
}

class _ImageWallpaperState extends State<ImageWallpaper> {


  Future<void> setWallpaperOnBothScreen() async {
    String result;
    String tempDir = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DCIM);
    File path = File((tempDir + '/${widget.name}') + '/${widget.filename}');

    try {
      result = (await WallpaperManager.setWallpaperFromFile(
          path.path, WallpaperManager.BOTH_SCREEN)) as String;
    } on PlatformException {
      result = 'Failed to get wallpaper.';
    }

    if (!mounted) return;
  }

  Future<void> setWallpaperOnHomeScreen() async {
    String result;
    String tempDir = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DCIM);
    File path = File((tempDir + '/${widget.name}') + '/${widget.filename}');

    try {
      result = (await WallpaperManager.setWallpaperFromFile(
          path.path, WallpaperManager.HOME_SCREEN)) as String;
    } on PlatformException {
      result = 'Failed to get wallpaper.';
    }
    if (!mounted) return;
  }


  Future<void> setWallpaperOnLockScreen() async {
    String result;
    String tempDir = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DCIM);
    File path = File((tempDir + '/${widget.name}') + '/${widget.filename}');

    try {
      result = (await WallpaperManager.setWallpaperFromFile(
          path.path, WallpaperManager.LOCK_SCREEN)) as String;
    } on PlatformException {
      result = 'Failed to get wallpaper.';
    }
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Wallpaper'),
        ),
      body: Container(
          child: Image.file(
            widget.path1,
            width: width * 1.0,
            height: height * 0.8,
          )
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home,
                  color: Colors.white, size: 25.0,
              ),
              onPressed: () {
                setWallpaperOnHomeScreen();
                Navigator.pop(context , true);
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.lock,
                color: Colors.white,
                size: 25.0,
              ),
              onPressed: () {
                setWallpaperOnLockScreen();
                Navigator.pop(context , true);
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.add_to_home_screen_rounded,
                color: Colors.white,
                size: 25.0,
              ),
              onPressed: () async {
                setWallpaperOnBothScreen();
                Navigator.pop(context , true);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// child: Image.file(
// widget.path1,
// width: width * 1.0,
// height: height * 0.8,
// )
