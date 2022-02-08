// ignore_for_file: unnecessary_import, prefer_const_constructors_in_immutables, deprecated_member_use, prefer_initializing_formals, use_key_in_widget_constructors, unused_import

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:photogallery/viewer.dart';
import 'package:transparent_image/transparent_image.dart';

class AlbumPage extends StatefulWidget {
  final Album album;
  final String name;

  AlbumPage(Album album, this.name) : album = album;

  @override
  State<StatefulWidget> createState() => AlbumPageState();
}

class AlbumPageState extends State<AlbumPage> {
  List<Medium>? _media;

  @override
  void initState() {
    super.initState();
    initAsync();
  }

  void initAsync() async {
    MediaPage mediaPage = await widget.album.listMedia();
    setState(() {
      _media = mediaPage.items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(widget.album.name ?? "Unnamed Album"),
          backgroundColor: Colors.black,
          actions: <Widget>[
            PopupMenuButton(
                elevation: 1.0,
                itemBuilder: (context) => [
                      PopupMenuItem(
                        child: FlatButton(
                          child: const Text(
                            'Delete',
                            style: TextStyle(fontSize: 15.0),
                          ),
                          onPressed: () {
                            // setState(() => ThumbnailProvider.removeAt(medium.id));
                          },
                        ),
                      )
                    ])
          ],
        ),
        body: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 1.0,
          crossAxisSpacing: 1.0,
          children: <Widget>[
            ..._media!.map(
              (medium) => GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ViewerPage(medium: medium, name: widget.name)));
                },
                child: Container(
                  color: Colors.grey[300],
                  child: FadeInImage(
                    fit: BoxFit.cover,
                    placeholder: MemoryImage(kTransparentImage),
                    image: ThumbnailProvider(
                      mediumId: medium.id,
                      mediumType: medium.mediumType,
                      highQuality: true,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
