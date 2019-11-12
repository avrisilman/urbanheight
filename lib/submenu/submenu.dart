import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbanheight/buildingmanagement/building.dart';
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

    String url =
        Api.serviceApi + '/api/submenu/' + prefs.getInt("menuId").toString();

    var response = await http.get(Uri.encodeFull(url),
        headers: {'authorization': prefs.getString("token")});

    setState(() {
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
                        flex: 1,
                        child: Container(
                          margin: const EdgeInsets.only(top: 13.0),
                          height: 30.0,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "   Pilih Kategori",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
            Flexible(
                flex: 2,
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemCount: data == null ? 0 : data.length,
                      itemBuilder: (BuildContext context, i) {
                        //if (index < 50)
                        return Container(
                           decoration: new BoxDecoration(
                color: Colors.blue[50],
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(8.0),
                    topRight: const Radius.circular(8.0),
                    bottomLeft: const Radius.circular(8.0),
                    bottomRight: const Radius.circular(8.0))),
                          padding: EdgeInsets.all(20.0),
                          child: new GestureDetector(
                            onTap: () => _onTileClicked(data[i]["id"]),
                            child: Center(
                              child: GridTile(
                                footer: Text(
                                  data[i]["nameSubMenu"],
                                  textAlign: TextAlign.center, style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
                                ),
                                header: Text(
                                  '',
                                  textAlign: TextAlign.center,
                                ),
                                child: Icon(Icons.access_alarm,
                                    size: 40.0, color: Colors.red),
                              ),
                            ),
                          ),
                          //color: Colors.indigo[50],
                          margin: EdgeInsets.all(1.0),
                        );
                      },
                    ),
                    //color: Colors.lightBlue[50],
                  ),
                )),
          ],
        ));
  }

  _onTileClicked(int id) {
    prefs.setInt('subId', id);
    Navigator.of(context).push(new MaterialPageRoute(
      builder: (BuildContext context) => new Building(),
    ));
  }
}
