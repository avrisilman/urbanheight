import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:urbanheight/login/code.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:urbanheight/service/api.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Signin extends StatefulWidget {
   static String tag = 'signin';
  @override
  _SigninPageState createState() => new _SigninPageState();
}

class _SigninPageState extends State<Signin> {
  TextEditingController emailController = new TextEditingController();

  var progBar = 1;

  void signin() async {
    var url = Api.serviceApi + '/signin';
    final response = await http.post(url, body: {"email": emailController.text});
    final data = jsonDecode(response.body);
    final message = data['message'];

    setState(() {
      if (message == 'success') {
       progBar = 1;
       Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new Code(),
        ));
    } else {
      progBar = 1;
        _onAlertButtonsPressed(context);
    }
    });

  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 14.0,
      color: Colors.blue,
    );

    LinearProgressIndicator psBar;

    if (progBar == 2) {
      psBar = LinearProgressIndicator(backgroundColor: Colors.blue);
    } else if (progBar == 1) {
      psBar = null;
    }

    final lbl = Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.only(left: 15.0),
          child: Text(
            "LOGIN",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28.0,
                color: Colors.blue),
          ),
        ));

    final imgUrl = CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 80.0,
        child: Image.network(
          'https://urbanheight.000webhostapp.com/logo_uhr.png',
          height: 150.0,
          width: 150.0,
        ));

    final txt = Text(
      "Urban Height",
      style: TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
      ),
      textAlign: TextAlign.center,
    );

    final email = Padding(
        padding: EdgeInsets.all(8.0),
        child: TextField(
          controller: emailController,
          obscureText: false,
          style: style,
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.email,
                color: Colors.blue,
              ),
              contentPadding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
              hintText: "Email",
              border: OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(32.0))),
        ));

    final signinButton = Padding(
      padding: EdgeInsets.all(8.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          setState(() {
            progBar = 2;
          });
          signin();
        },
        color: Colors.blue,
        child: Text('LOGIN',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.0)),
      ),
    );


    return Scaffold(
        bottomSheet: psBar,
        backgroundColor: Colors.white,
        body: Align(
          alignment: Alignment.topCenter,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 4.0, right: 5.0, top: 40.0),
            children: <Widget>[lbl, imgUrl, txt, email, signinButton],
          ),
        ));
  }

  _onClickReg() {
    Navigator.of(context).push(new MaterialPageRoute(
      //builder: (BuildContext context) => new Signup(),
    ));
  }

   void _onAlertButtonsPressed(BuildContext context) {
      Alert(context: context, title: "INVALID EMAIL", desc: "Harap Masukan Email dengan benar atau Hubungi Building Management").show();
  }

}
