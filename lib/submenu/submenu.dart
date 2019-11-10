import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbanheight/service/api.dart';

class SubMenu extends StatefulWidget {

  static String tag = 'submenu';
  
  @override
  _SubMenuState createState() => new _SubMenuState();

}

class _SubMenuState extends State<SubMenu> {
  SharedPreferences prefs;
  List data;

  Future<String> makeRequest() async {
    prefs = await SharedPreferences.getInstance();

    String url = Api.serviceApi + '/api/submenu/'+ prefs.getInt("menuId").toString();

    var response = await http.get(Uri.encodeFull(url),
        headers: {'authorization': prefs.getString("token")});

    setState(() {
      Fluttertoast.showToast(
          msg: prefs.getInt('menuId').toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 20.0);
      var extractdata = jsonDecode(response.body);
      data = extractdata['result'];
    });
  }

  @override
  void initState() {
    this.makeRequest();
  }

  @override
  Widget build(BuildContext context) {
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
            'MENU',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.add_circle_outline, color: Colors.blue),
                onPressed: null)
          ],
        ),
        body: Column(
          children: <Widget>[
            Flexible(
                flex: 2,
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4),
                        itemCount: data == null ? 0 : data.length,
                        itemBuilder: (BuildContext context, i) {
                          return Container(
                              padding: EdgeInsets.all(5.0),
                              child: new GestureDetector(
                                
                                child: Center(
                                  child: GridTile(
                                    footer: Text(
                                      data[i]["nameSubMenu"],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 7),
                                    ),
                                    child: Icon(Icons.access_alarm,
                                        size: 40.0, color: Colors.red),
                                  ),
                                ),
                              ));
                        }),
                    color: Colors.white,
                  ),
                )),
          ],
        ));
  }
}
