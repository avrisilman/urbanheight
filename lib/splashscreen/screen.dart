import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:urbanheight/login/login.dart';
import 'package:urbanheight/tab/mainhome.dart';

class Screen extends StatefulWidget {
  static String tag = 'screen';

  @override
  _ScreenState createState() => new _ScreenState();
}

class _ScreenState extends State<Screen> {
  SharedPreferences prefs;

  Future<String> makeRequest() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getString("token") != null) {
        Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new MainHome(),
        ));
      } else {
        Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new Login(),
        ));
      }
    });
  }

  @override
  void initState() {
    this.makeRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Container(
        child: Center(
          child: Column(
            // center the children
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "SPLAS SCREEN",
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
