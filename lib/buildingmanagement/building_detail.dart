import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbanheight/buildingmanagement/building_detail.dart';
import 'package:urbanheight/service/api.dart';

class BuildingDetail extends StatefulWidget {
  @override
  _BuildingDetailState createState() => new _BuildingDetailState();
}

class _BuildingDetailState extends State<BuildingDetail> {
  String bm = '';
  SharedPreferences prefs;

  Future<String> makeRequest() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      bm = prefs.getString("bm");
    });
  }

  @override
  void initState() {
    this.makeRequest();
  }

  @override
  Widget build(BuildContext context) {
    var statusAirListrik;

    var icons;
    try {
      if (prefs.getInt('subId') == 31) {
        icons = Icon(
          Icons.ac_unit,
          color: Colors.white,
          size: 70.0,
        );
      } else if (prefs.getInt('subId') == 32) {
        icons = Icon(
          Icons.offline_bolt,
          color: Colors.white,
          size: 70.0,
        );
      } else {
        print('object');
      }
    } catch (e) {
      print("Error occured: ");
    } finally {
      print("Error occured: ");
    }

 try {
    if (prefs.getString('status_air_listrik') == '0') {
      statusAirListrik = Text(
        'Belum Lunas',
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      );
    } else if (prefs.getString('status_air_listrik') == '1') {
      statusAirListrik = Text(
        'Lunas',
        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
      );
    } else {
        print('object');
      }
    } catch (e) {
      print("Error occured: ");
    } finally {
      print("Error occured: ");
    }

    final appBar = SingleChildScrollView(
      padding: new EdgeInsets.only(bottom: 20.0),
      child: new Center(
        child: new Form(
          //key: _formKey,
          child: new Center(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new Card(
                  color: Colors.blue,
                  margin:
                      new EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  elevation: 4.0,
                  child: new Padding(
                    padding: new EdgeInsets.all(50.0),
                    child: new Row(
                      children: <Widget>[
                        new Container(
                          child: icons,
                        ),
                        Container(
                          child: Text(
                            bm,
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    final fullName = ListTile(
      leading: Icon(
        Icons.account_circle,
        color: Colors.blue,
      ),
      title: Text(prefs.getString('fullName')),
    );

    final unit = ListTile(
      leading: Icon(
        Icons.business,
        color: Colors.blue,
      ),
      title: Text(prefs.getString('unit')),
    );

    final standMeter = Row(
      children: <Widget>[
        Container(
          margin: new EdgeInsets.only(
              left: 20.0, right: 5.0, bottom: 5.0, top: 5.0),
          width: 100,
          child: Text("Stand Meter",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0)),
        ),
        Text(":"),
        Text(prefs.getString('standMeter'),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0)),
      ],
    );

    final periode = Row(
      children: <Widget>[
        Container(
          margin: new EdgeInsets.only(
              left: 20.0, right: 5.0, bottom: 5.0, top: 5.0),
          width: 100,
          child: Text("Periode",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0)),
        ),
        Text(":"),
        Text(prefs.getString('periode'),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0)),
      ],
    );

    final total = Row(
      children: <Widget>[
        Container(
          margin: new EdgeInsets.only(
              left: 20.0, right: 5.0, bottom: 5.0, top: 5.0),
          width: 100,
          child: Text("Total Bayar",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0)),
        ),
        Text(":"),
        Text(prefs.getString('amount'),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0)),
      ],
    );

    final status = Row(
      children: <Widget>[
        Container(
          margin: new EdgeInsets.only(
              left: 20.0, right: 5.0, bottom: 5.0, top: 5.0),
          width: 100,
          child: Text("Status Bayar",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0)),
        ),
        Text(":"),
        Text(statusAirListrik,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0)),
      ],
    );

    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            Center(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 4.0, right: 5.0, top: 80.0),
                children: <Widget>[
                  appBar,
                  fullName,
                  unit,
                  standMeter,
                  periode,
                  total,
                  status,
                ],
              ),
            ),
          ],
        ));
  }
}
