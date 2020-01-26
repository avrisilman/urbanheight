import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:exif/exif.dart';
import 'package:flutter/material.dart';
import 'package:urbanheight/service/api.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:urbanheight/tab/mainhome.dart';

class PinjamAlatAdd extends StatefulWidget {
  @override
  _PinjamAlatAddPageState createState() => new _PinjamAlatAddPageState();
}

class _PinjamAlatAddPageState extends State<PinjamAlatAdd> {
  File _imageFile;
  String _base64 = '0';
  SharedPreferences prefs;
  TextEditingController titleController = new TextEditingController();
  TextEditingController conditionController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();
  TextEditingController ketController = new TextEditingController();

  void save() async {
    prefs = await SharedPreferences.getInstance();
    var url = Api.serviceApi + '/api/sewa-alat/'+prefs.getInt("usersId").toString()+"/sub/"+prefs.getInt("subId").toString();
    final response = await http.post(url, headers: {
      'authorization': prefs.getString("token")
    }, body: {
      "title": titleController.text,
      "lamaPinjam": conditionController.text,
      "imgUrl": _base64,
      "price": priceController.text,
      "information": ketController.text,
      "handphone":prefs.getString("handphone")
    });
    final data = jsonDecode(response.body);
    final message = data['message'];

    setState(() {
      if (message == 'success') {
         Alert(
      context: context,
      type: AlertType.warning,
      title: "TAMBAH SEWA ALAT",
      desc:
          "SUKSES",
      buttons: [
        DialogButton(
          child: Text(
            "CANCEL",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "HOME",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new MainHome(),
            ));
          },
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    ).show();
      } else {
        Alert(
      context: context,
      type: AlertType.warning,
      title: "TAMBAH SEWA ALAT",
      desc:
          "Gagal Terkirim",
      buttons: [
        DialogButton(
          child: Text(
            "CANCEL",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "HOME",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new MainHome(),
            ));
          },
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    ).show();
      }
    });
  }

  Widget _buildImagePreview() {
    if (_base64 == '0') {
      return Container(
        child:
        IconButton(
            icon: new Icon(
              Icons.photo_camera,
              color: Colors.blue[100],
              size: 84.0,
            ),
           // color: Colors.blue,
            onPressed: () => {},
          ),
        height: 200.0,
        color: Colors.grey[200],
      );
    }

    return Image.memory(
      base64.decode(_base64),
      fit: BoxFit.cover,
      height: 200.0,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.topCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 14.0,
      color: Colors.blue,
    );

    final cmr = RaisedButton(
      color: Colors.blue,
      child: IconButton(
        icon: new Icon(
          Icons.camera_alt,
          color: Colors.white,
        ),
        color: Colors.blue,
        onPressed: () => Navigator.of(context).pop(),
      ),
      onPressed: () {
        _openImagePicker(context);
      },
    );

    final title = Padding(
        padding: EdgeInsets.all(8.0),
        child: TextField(
          controller: titleController,
          obscureText: false,
          style: style,
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.assignment,
                color: Colors.blue,
              ),
              contentPadding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
              hintText: "Judul",
              border: OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.green),
                  borderRadius: BorderRadius.circular(32.0))),
        ));

        final condition = Padding(
        padding: EdgeInsets.all(8.0),
        child: TextField(
          controller: conditionController,
          obscureText: false,
          style: style,
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.assignment,
                color: Colors.blue,
              ),
              contentPadding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
              hintText: "Lama Pinjam",
              border: OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.green),
                  borderRadius: BorderRadius.circular(32.0))),
        ));

        final price = Padding(
        padding: EdgeInsets.all(8.0),
        child: TextField(
          controller: priceController,
          obscureText: false,
          style: style,
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.assignment,
                color: Colors.blue,
              ),
              contentPadding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
              hintText: "Harga",
              border: OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.green),
                  borderRadius: BorderRadius.circular(32.0))),
        ));

        final ket = Padding(
        padding: EdgeInsets.all(8.0),
        child: TextField(
          controller: ketController,
          obscureText: false,
          style: style,
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.assignment,
                color: Colors.blue,
              ),
              contentPadding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
              hintText: "Keterangan",
              border: OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.green),
                  borderRadius: BorderRadius.circular(32.0))),
        ));

    final btn = Padding(
      padding: EdgeInsets.all(8.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          save();
        },
        color: Colors.blue,
        child: Text('SAVE',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.0)),
      ),
    );

    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.white,
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back_ios,
              color: Colors.blue,
            ),
            color: Colors.blue,
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: new Text(
            'TAMBAH SEWA ALAT',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Align(
          alignment: Alignment.topCenter,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 4.0, right: 5.0, top: 40.0),
            children: <Widget>[_buildImagePreview(), cmr, title, condition, price, ket, btn],
          ),
        ));
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

  void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(source: source, maxHeight: 450, maxWidth: 450)
        .then((File image) async {
      image = await rotateAndCompressAndSaveImage(image);
      setState(() {
        _imageFile = image;
        _base64 = base64.encode(_imageFile.readAsBytesSync());
      });
      Navigator.pop(context);
    });
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
