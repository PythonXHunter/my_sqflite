import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'database_helper.dart';
import 'image_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final dbHelper = DatabaseHelper.instance;
  List<ImageModel> images = [];

  @override
  void initState() {
    super.initState();
    _queryImages();
  }

  // Query all images from the database
  void _queryImages() async {
    final allImages = await dbHelper.getAllImages();
    setState(() {
      images = allImages;
    });
  }

  // Insert a new image into the database
  void _insertImage(File file) async {
    final now = DateTime.now();

    // Pick an image file
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      final file = File(result.files.single.path!);
      if (await file.exists()) {
        final image = ImageModel(
          filePath: file.path,
          fileName: basename(file.path),
          dateAdded: now,
        );
        final id = await dbHelper.insertImage(image);
        setState(() {
          images.add(image);
        });
      } else {
        print('Handle the case where the file does not exist');
      }
    } else {
      print('User canceled the picker');
    }
  }

  void _pickImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      final file = File(result.files.single.path!);
      _insertImage(file);
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Image Database'),
          actions: [
            IconButton(
              onPressed: _queryImages,
              icon: Icon(Icons.refresh),
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: images.length,
                itemBuilder: (context, index) {
                  final image = images[index];
                  return ListTile(
        title: Text(image.fileName),
        subtitle: Text(image.filePath),
        trailing: Text(image.dateAdded.toString()),
        leading: Mycon(image: image),
      );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: ElevatedButton(
                child: Text('Add Image'),
                onPressed: _pickImage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Mycon extends StatelessWidget {
  const Mycon({
    super.key,
    required this.image,
  });

  final ImageModel image;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.file(File(image.filePath)),
    );
  }
}
