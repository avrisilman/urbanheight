import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:urbanheight/programmatically/passcode.dart';
import 'package:urbanheight/tab/mainhome.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:urbanheight/service/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Code extends StatefulWidget {
  static String tag = 'code';
  @override
  _CodePageState createState() => new _CodePageState();
}

class _CodePageState extends State<Code> {
  void postCode(String passcode) async {
    var url = Api.serviceApi+'/verifi';
    final response = await http.post(url, body: {"code": passcode});
    final data = jsonDecode(response.body);

    final noIdentity = data['result']['noIdentity'];
    final fullName = data['result']['fullName'];
    final handphone = data['result']['handphone'];
    final email = data['result']['email'];
    final unit = data['result']['unit'];
    final address = data['result']['address'];
    final token = data['result']['token'];
    final roleId = data['result']['roleId'];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString("noIdentity", noIdentity);
      prefs.setString("fullName", fullName);
      prefs.setString("handphone", handphone);
      prefs.setString("email", email);
      prefs.setString("unit", unit);
      prefs.setString("address", address);
      prefs.setString("token", token);
      prefs.setInt("roleId", roleId);
    });

    if (token != null) {
      Navigator.of(context).pushNamed(MainHome.tag);
     
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
    final backgrounds = Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(top: 40.0),
                child: Center(
                  child: Text(
                    "VERIFIKASI",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.black),
                  ),
                )),
            Container(
                margin: const EdgeInsets.only(top: 40.0),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Gunakan kode verifikasi yang telah",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                            color: Colors.black),
                      ),
                      Text(
                        "anda dapatkan dari Alamat Email",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                            color: Colors.black),
                      ),
                    ],
                  ),
                )),
          ],
        )
      ],
    );

    final code = PasscodeTextField(
      onTextChanged: (passcode) {
        postCode(passcode);
      },
      totalCharacters: 4,
      borderColor: Colors.black,
      passcodeType: PasscodeType.number,
    );

    /*final code2 = TextField(
                controller: controllerCode,
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
                    )));*/

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          //postCode();
        },
        color: Colors.blue,
        child: Text('VERIFIKASI', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            backgrounds,
            Center(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 4.0, right: 5.0, top: 80.0),
                children: <Widget>[
                  code,
                 // loginButton,
                ],
              ),
            ),
          ],
        ));
  }
}
