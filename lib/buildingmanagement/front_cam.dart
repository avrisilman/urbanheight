import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'dart:typed_data';
import 'package:exif/exif.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  File _imageFile;
  String base64Image = '';
  Uint8List bytes;

  void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(
      source: source,
    ).then((File image) async {
      image = await rotateAndCompressAndSaveImage(image);
      setState(() {
        _imageFile = image;

        base64Image = base64Encode(_imageFile.readAsBytesSync());
        bytes = base64.decode(base64Image);
      });
      Navigator.pop(context);
    });
  }

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150.0,
          padding: EdgeInsets.all(10.0),
          child: Column(children: [
            Text(
              'Pick an Image',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10.0,
            ),
            FlatButton(
              textColor: Theme.of(context).primaryColor,
              child: Text('Use Camera'),
              onPressed: () {
                _getImage(context, ImageSource.camera);
              },
            ),
            FlatButton(
              textColor: Theme.of(context).primaryColor,
              child: Text('Use Gallery'),
              onPressed: () {
                _getImage(context, ImageSource.gallery);
              },
            )
          ]),
        );
      },
    );
  }

  Widget _buildImagePreview() {
    if (_imageFile == null) {
      return Container(
        height: 200.0,
        color: Colors.grey,
      );
    }

    return Image.memory(
      bytes,
      fit: BoxFit.cover,
      height: 200.0,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.topCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Bug'),
      ),
      body: Column(
        children: <Widget>[
          _buildImagePreview(),
          SizedBox(
            height: 20.0,
          ),
          RaisedButton(
            child: Text('Select image'),
            onPressed: () {
              _openImagePicker(context);
            },
          ),
          Text(
            bytes.toString(),
            style: TextStyle(color: Colors.black),
          )
        ],
      ),
    );
  }

  Future<File> rotateAndCompressAndSaveImage(File image) async {
    int rotate = 0;
    List<int> imageBytes = await image.readAsBytes();
    Map<String, IfdTag> exifData = await readExifFromBytes(imageBytes);

    if (exifData != null &&
        exifData.isNotEmpty &&
        exifData.containsKey("Image Orientation")) {
      IfdTag orientation = exifData["Image Orientation"];
      int orientationValue = orientation.values[0];

      if (orientationValue == 3) {
        rotate = 180;
      }

      if (orientationValue == 6) {
        rotate = -90;
      }

      if (orientationValue == 8) {
        rotate = 90;
      }
    }

    List<int> result = await FlutterImageCompress.compressWithList(imageBytes,
        quality: 100, rotate: rotate);

    await image.writeAsBytes(result);

    return image;
  }
}
