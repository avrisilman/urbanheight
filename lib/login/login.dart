import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:urbanheight/login/code.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:urbanheight/service/api.dart';
import 'package:urbanheight/programmatically/beauty_textfield.dart';

class Login extends StatefulWidget {
  static String tag = 'login';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<Login> {

  String email = '';
  void printText(String text) async {
    email = text;
  }

  void postLogin() async {
    var url = Api.serviceApi + '/signin';
    final response = await http.post(url, body: {"email": email});
    final data = jsonDecode(response.body);
    final message = data['message'];

    if (message == 'success') {
      Navigator.of(context).pushNamed(Code.tag);
    } else {
      Fluttertoast.showToast(
          msg: "Email Tidak Terdaftar.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.blue,
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
            'https://www.meobserver.org/wp-content/uploads/2017/05/Apple-Logo-Transparent-PNG.png',
            height: 150.0,
            width: 150.0,
          )),
    );

    final lbl = Text(
      "   Login",
      style: TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
      ),
    );

    final email = BeautyTextfield(
      width: double.maxFinite,
      height: 60,
      accentColor: Colors.blue[100], // On Focus Color
      textColor: Colors.black,
      //duration: Duration(milliseconds: 500),
      inputType: TextInputType.text,
      backgroundColor: Colors.blue,
      prefixIcon: Icon(
        Icons.email,
        color: Colors.white,
      ),
      placeholder: "Email",
      onTap: () {
        print('Click');
      },
      onChanged: (text) {
        printText(text);
      },
      onSubmitted: (data) {
        print(data.length);
      },
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          postLogin();
        },
        color: Colors.white,
        child: Text('Log In',
            style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 16.0)),
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
            lbl,
            email,
            loginButton,
          ],
        ),
      ),
    );
  }
}
