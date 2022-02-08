// ignore_for_file: import_of_legacy_library_into_null_safe, prefer_const_constructors, deprecated_member_use, unnecessary_null_comparison, avoid_print, unnecessary_new, unnecessary_string_interpolations, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, unused_import

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photogallery/album.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:transparent_image/transparent_image.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Album>? _albums;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loading = true;
    initAsync();
  }

  Future<void> initAsync() async {
    if (await _promptPermissionSetting()) {
      List<Album> albums =
          await PhotoGallery.listAlbums(mediumType: MediumType.image);
      setState(() {
        _albums = albums;
        _loading = false;
      });
    }
    setState(() {
      _loading = false;
    });
  }

  Future<bool> _promptPermissionSetting() async {
    if (Platform.isIOS &&
            await Permission.storage.request().isGranted &&
            await Permission.photos.request().isGranted ||
        Platform.isAndroid && await Permission.storage.request().isGranted) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      // themeMode: ThemeMode.dark,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Albums'),
          backgroundColor: Colors.black,
          // actions: <Widget>[
          //   PopupMenuButton(
          //       elevation: 1.0,
          //       itemBuilder:(context) => [
          //         PopupMenuItem(
          //           child: FlatButton(
          //             child: const Text("Group"),
          //             onPressed: () {
          //
          //               showDialog(
          //                   context: context,
          //                   builder: (BuildContext context) {
          //                     return AlertDialog(
          //                       scrollable: true,
          //                       title: const Text('New Group'),
          //                       content: Padding(
          //                         padding: const EdgeInsets.all(8.0),
          //                         child: Form(
          //                           child: Column(
          //                             children: <Widget>[
          //                               TextFormField(
          //                                 decoration: const InputDecoration(
          //                                   labelText: 'New',
          //                                   // icon: Icon(Icons.account_box),
          //                                 ),
          //                               ),
          //                             ],
          //                           ),
          //                         ),
          //                       ),
          //                       actions: [
          //                         RaisedButton(
          //                           child: const Text("Ok"),
          //                           onPressed: () {},
          //                         ),
          //                         RaisedButton(
          //                             child: const Text("Cancel"),
          //                             onPressed: () {
          //                               Navigator.pop(context);
          //                             })
          //                       ],
          //                     );
          //                   });
          //             },
          //           ),
          //           value: 1,
          //         ),
          //         PopupMenuItem(
          //           child: FlatButton(
          //             child: const Text('Setting', style: TextStyle(fontSize: 15.0),),
          //             onPressed: () {},
          //           ),
          //           value: 2,
          //         )
          //       ]
          //   )
          // ],
        ),
        body: _loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : LayoutBuilder(
                builder: (context, constraints) {
                  double gridWidth = (constraints.maxWidth - 20) / 3;
                  double gridHeight = gridWidth + 33;
                  double ratio = gridWidth / gridHeight;
                  return Container(
                    padding: const EdgeInsets.all(5),
                    child: GridView.count(
                      childAspectRatio: ratio,
                      crossAxisCount: 3,
                      mainAxisSpacing: 5.0,
                      crossAxisSpacing: 5.0,
                      children: <Widget>[
                        ..._albums!.map(
                          (album) => GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      AlbumPage(album, album.name!)));
                            },
                            child: Column(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: Container(
                                    color: Colors.grey[300],
                                    height: gridWidth,
                                    width: gridWidth,
                                    child: FadeInImage(
                                      fit: BoxFit.cover,
                                      placeholder:
                                          MemoryImage(kTransparentImage),
                                      image: AlbumThumbnailProvider(
                                        albumId: album.id,
                                        mediumType: album.mediumType,
                                        highQuality: true,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  padding: const EdgeInsets.only(left: 2.0),
                                  child: Text(
                                    album.name ?? "Unnamed Album",
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      height: 1.2,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  padding: const EdgeInsets.only(left: 2.0),
                                  child: Text(
                                    album.count.toString(),
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      height: 1.2,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
