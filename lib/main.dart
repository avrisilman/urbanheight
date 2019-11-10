import 'package:flutter/material.dart';
import 'package:urbanheight/login/login.dart';
import 'package:urbanheight/login/code.dart';
import 'package:urbanheight/submenu/submenu.dart';
import 'package:urbanheight/tab/mainhome.dart';
import 'package:urbanheight/splashscreen/screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    Screen.tag: (context) => Screen(),
    Login.tag: (context) => Login(),
    Code.tag: (context) => Code(),
    MainHome.tag: (context) => MainHome(),
    SubMenu.tag: (context) => SubMenu(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kodeversitas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        fontFamily: 'Nunito',
      ),
      home: Screen(),
      //home: Login(),
      //home: Code(),
      //home: MainHome(),
      // home: SubMenu(),
      routes: routes,
    );
  }
}
