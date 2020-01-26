import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbanheight/event/event.dart';
import 'package:urbanheight/numpang/numpang.dart';
import 'package:urbanheight/service/api.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class NumpangAdd extends StatefulWidget {
  @override
  _NumpangAddState createState() => new _NumpangAddState();
}

class _NumpangAddState extends State<NumpangAdd> {
  SharedPreferences prefs;
  TextEditingController goingController = new TextEditingController();
  TextEditingController hargaController = new TextEditingController();
  TextEditingController clockController = new TextEditingController();
  TextEditingController dateController = new TextEditingController();
  TextEditingController infController = new TextEditingController();

  void save() async {
    prefs = await SharedPreferences.getInstance();
    var url =
        Api.serviceApi + '/api/numpang/' + prefs.getInt("usersId").toString();
    ;
    final response = await http.post(url, headers: {
      'authorization': prefs.getString("token")
    }, body: {
      "goingto": goingController.text,
      "harga": hargaController.text,
      "clock": clockController.text,
      "date": dateController.text,
      "information": infController.text
    });
    final data = jsonDecode(response.body);
    final message = data['message'];

    setState(() {
      if (message == 'success') {
        Fluttertoast.showToast(
            msg: "Sukses",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new Numpang(),
        ));
      } else {
        Fluttertoast.showToast(
            msg: "Gagal Terkirim",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 14.0,
      color: Colors.green,
    );

    final content = Card(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: goingController,
                  obscureText: false,
                  style: style,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.motorcycle,
                        color: Colors.blue,
                      ),
                      contentPadding:
                          EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                      hintText: "Tujuan",
                      border: OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.circular(32.0))),
                )),
            Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: hargaController,
                  obscureText: false,
                  style: style,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.euro_symbol,
                        color: Colors.blue,
                      ),
                      contentPadding:
                          EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                      hintText: "Harga",
                      border: OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.circular(32.0))),
                )),
            Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: clockController,
                  obscureText: false,
                  style: style,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.access_time,
                        color: Colors.blue,
                      ),
                      contentPadding:
                          EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                      hintText: "Jam",
                      border: OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.circular(32.0))),
                )),
            Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: dateController,
                  obscureText: false,
                  style: style,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.date_range,
                        color: Colors.blue,
                      ),
                      contentPadding:
                          EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                      hintText: "Tanggal",
                      border: OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.circular(32.0))),
                )),
            Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: infController,
                  obscureText: false,
                  style: style,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.assignment,
                        color: Colors.blue,
                      ),
                      contentPadding:
                          EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                      hintText: "Keterangan",
                      border: OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.circular(32.0))),
                )),
          ],
        ),
      ),
    );

    final signupButton = Padding(
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
            //tooltip: 'ddd',
            color: Colors.blue,
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: new Text(
            'NEBENG',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Align(
          alignment: Alignment.topCenter,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 4.0, right: 5.0, top: 5.0),
            children: <Widget>[content, signupButton],
          ),
        ));
  }
}
