import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbanheight/service/api.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Building extends StatefulWidget {
  static String tag = 'building';

  @override
  _BuildingState createState() => new _BuildingState();
}

class _BuildingState extends State<Building> {
  SharedPreferences prefs;
  List data;

  Future<String> makeRequest() async {
    prefs = await SharedPreferences.getInstance();

    String url = Api.serviceApi +
        '/api/subchildmenu/' +
        prefs.getInt("usersId").toString() +
        '/sub/' +
        prefs.getInt("subId").toString();

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
    var icons;
    try {
      if (prefs.getInt('subId') == 31) {
        icons = Icon(
          Icons.ac_unit,
          color: Colors.blue,
        );
        prefs.setString("bm", "Tagihan Air");
      } else if (prefs.getInt('subId') == 32) {
        icons = Icon(Icons.offline_bolt, color: Colors.yellow[800]);
        prefs.setString("bm", "Tagihan Listrik");
      } else {
        print('object');
      }
    } catch (e) {
      print("Error occured: ");
    } finally {
      print("Error occured: ");
    }

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
            'BUILDING MANAGEMENT',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: <Widget>[],
        ),
        body: Container(
          child: ListView.builder(
            itemCount: data == null ? 0 : data.length,
            itemBuilder: (BuildContext context, i) {
              return new Container(
                padding: const EdgeInsets.all(10.0),
                child: new GestureDetector(
                  onTap: () => _onTileClicked(
                    //  data[i]["id"],
                      data[i]["standMeter"],
                      data[i]["periode"],
                      data[i]["amount"],
                      data[i]["status"],
                      data[i]["date"],
                      data[i]["time"]),
                  child: new Card(
                    child: new ListTile(
                      leading: icons,
                      title: Text(data[i]["periode"]),
                      trailing: Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ));
  }

  _onTileClicked(String standMeter, String periode, String amount, String status, String date, String time) {

     final content = Card(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Container(
                    width: 120.0,
                    child: Text(
                      "Nama",
                      style: TextStyle(fontSize: 8),
                    ),
                  ),
                  Container(
                    child: Text(":"),
                  ),
                  Expanded(
                    child: Text(
                      prefs.getString("fullName"),
                      maxLines: 20,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 8),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.black26,
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Container(
                    width: 120.0,
                    child: Text(
                      "Unit",
                      style: TextStyle(fontSize: 8),
                    ),
                  ),
                  Container(
                    child: Text(":"),
                  ),
                  Expanded(
                    child: Text(
                      prefs.getString("unit"),
                      maxLines: 20,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 8),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.black26,
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Container(
                    width: 120.0,
                    child: Text(
                      "Stand Meter",
                      style: TextStyle(fontSize: 8),
                    ),
                  ),
                  Container(
                    child: Text(":"),
                  ),
                  Expanded(
                    child: Text(
                      standMeter,
                      maxLines: 20,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 8),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.black26,
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Container(
                    width: 120.0,
                    child: Text(
                      "Periode",
                      style: TextStyle(fontSize: 8),
                    ),
                  ),
                  Container(
                    child: Text(":"),
                  ),
                  Expanded(
                    child: Text(
                      periode,
                      maxLines: 20,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 8),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.black26,
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Container(
                    width: 120.0,
                    child: Text(
                      "Total",
                      style: TextStyle(fontSize: 8),
                    ),
                  ),
                  Container(
                    child: Text(":"),
                  ),
                  Expanded(
                    child: Text(
                      amount,
                      maxLines: 20,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 8),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.black26,
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Container(
                    width: 120.0,
                    child: Text(
                      "Status",
                      style: TextStyle(fontSize: 8),
                    ),
                  ),
                  Container(
                    child: Text(":"),
                  ),
                  Expanded(
                    child: Text(
                      status,
                      maxLines: 20,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 8),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.black26,
            ),
          ],
        ),
      ),
    );

    Alert(
        context: context,
        title: "AIR",
        content: Align(
          alignment: Alignment.topCenter,
          child: ListView(
            shrinkWrap: true,
            //padding: EdgeInsets.only(left: 4.0, right: 5.0, top: 5.0),
            children: <Widget>[content],
          ),
        )).show();

  }
}
