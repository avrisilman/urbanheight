import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:urbanheight/login/code.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:urbanheight/service/api.dart';

class Login extends StatefulWidget {
  static String tag = 'login';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<Login> {
  TextEditingController controllerEmail = new TextEditingController();

  void postLogin() async {
    var url = Api.serviceApi +'/signin';
    final response =
        await http.post(url, body: {"email": controllerEmail.text});
    final data = jsonDecode(response.body);
    final message = data['message'];

    if (message == 'success') {
      Navigator.of(context).pushNamed(Code.tag);
    } else {
      Fluttertoast.showToast(
          msg: "Mohon Maaf Email Tidak Terdaftar...!!!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 20.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 80.0,
          child: Image.network(
            'https://www.freelogodesign.org/Content/img/logo-samples/cafeespresso.png',
            height: 150.0,
            width: 150.0,
          )),
    );

    final email = TextField(
        controller: controllerEmail,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blueAccent,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            hintText: "Masukan Email",
            labelText: "Email",
            prefixIcon: Icon(
              Icons.email,
              color: Colors.blue,
            )));

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          postLogin();
        },
        color: Colors.blue,
        child: Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 4.0, right: 5.0),
          children: <Widget>[
            logo,
            email,
            loginButton,
          ],
        ),
      ),
    );
  }
}
