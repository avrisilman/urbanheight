import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbanheight/buildingmanagement/building_detail.dart';
import 'package:urbanheight/service/api.dart';

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
                      data[i]["id"],
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

  _onTileClicked(id, standMeter, periode, amount, status, date, time) {
      prefs.setInt('buildingId', id);
      prefs.setString('standMeter', standMeter);
      prefs.setString('periode', periode);
      prefs.setString('amount', amount);
      prefs.setString('status_air_listrik', status);
      prefs.setString('date', date);
      prefs.setString('time', time);
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new BuildingDetail(),
      ));
  }
}
