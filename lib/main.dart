import 'package:flutter/material.dart';
import 'package:urbanheight/buildingmanagement/building.dart';
import 'package:urbanheight/login/login.dart';
import 'package:urbanheight/login/code.dart';
import 'package:urbanheight/submenu/submenu.dart';
import 'package:urbanheight/tab/mainhome.dart';
import 'package:urbanheight/splashscreen/screen.dart';
import 'package:flutter/services.dart' ;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    Screen.tag: (context) => Screen(),
    Signin.tag: (context) => Signin(),
    Code.tag: (context) => Code(),
    MainHome.tag: (context) => MainHome(),
    SubMenu.tag: (context) => SubMenu(),
    Building.tag: (context) => Building(),
  };

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    return MaterialApp(
      title: 'Kodeversitas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        fontFamily: 'Nunito',
      ),
      home: Screen(),
      //home: Signin(),
      //home: Code(),
      //home: MainHome(),
      // home: SubMenu(),
      routes: routes,
    );
  }
}
