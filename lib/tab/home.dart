import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbanheight/service/api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:urbanheight/submenu/submenu.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  SharedPreferences prefs;
  List data;

  String nama = '';

  Future<String> makeRequest() async {
    prefs = await SharedPreferences.getInstance();

    String url =
        Api.serviceApi + '/api/menu/' + prefs.getInt("roleId").toString();

    var response = await http.get(Uri.encodeFull(url),
        headers: {'authorization': prefs.getString("token")});

    setState(() {
      nama = prefs.getString("fullName");
      var extractdata = jsonDecode(response.body);
      data = extractdata['result']['menus'];
    });
  }

  @override
  void initState() {
    this.makeRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 300.0,
          color: Colors.transparent,
          child: Container(
            decoration: new BoxDecoration(
                color: Colors.blue,
                borderRadius: new BorderRadius.only(
                    bottomLeft: const Radius.circular(40.0),
                    bottomRight: const Radius.circular(40.0))),
          ),
        ),
        Container(
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                              width: 20.0,
                              height: 20.0,
                              decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: new NetworkImage(
                                          "https://flaticons.net/gd/makefg.php?i=icons/Application/User-Profile.png&r=255&g=255&b=255")))),
                          Expanded(
                            child: Text(
                              nama,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(5.0),
                            width: 45.0,
                            height: 45.0,
                            child: Icon(
                              Icons.power_settings_new,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                          margin: const EdgeInsets.all(13.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Welcome to",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              Text(
                                "URBAN HEIGHT",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(""),
                              Text(
                                "Layanan digital untuk Apartement Urban Height",
                                textAlign: TextAlign.left,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Container(
                          margin: const EdgeInsets.only(top: 13.0),
                          height: 30.0,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "   Pilih Menu",
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
                        flex: 4,
                        child: Container(
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4),
                            itemCount: data == null ? 0 : data.length,
                            itemBuilder: (BuildContext context, i) {
                              return Container(
                                  padding: EdgeInsets.all(5.0),
                                  child: new GestureDetector(
                                    onTap: () => _onTileClicked(data[i]["id"]),
                                    //new SubMenu())),
                                    child: Center(
                                      child: GridTile(
                                        footer: Text(
                                          data[i]["nameMenu"],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 8),
                                        ),
                                        child: Icon(Icons.access_alarm,
                                            size: 30.0, color: Colors.blue),
                                      ),
                                    ),
                                  ));
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  _onTileClicked(int id) {
    prefs.setInt('menuId', id);
    Navigator.of(context).push(new MaterialPageRoute(
      builder: (BuildContext context) => new SubMenu(),
    ));
  }
}
