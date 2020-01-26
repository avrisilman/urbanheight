import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbanheight/info/info-detail.dart';
import 'package:urbanheight/service/api.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Info extends StatefulWidget {
 
  @override
  _InfoState createState() => new _InfoState();
}

class _InfoState extends State<Info> {
  SharedPreferences prefs;
  List data;

  Future<String> makeRequest() async {
    prefs = await SharedPreferences.getInstance();

    String url = Api.serviceApi +
        '/api/info';

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
            'INFO',
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
              //  padding: const EdgeInsets.all(10.0),
                child: new GestureDetector(
                  onTap: () => _onTileClicked(
                      data[i]["title"],
                      data[i]["information"],
                      data[i]["date"],
                      data[i]["time"]),
                  child: new Card(
                    child: new ListTile(
                      leading: Icon(
                        Icons.dashboard,
                        color: Colors.red,
                      ),
                      title: Text(data[i]["title"]),
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

  _onTileClicked(String title, String information, String date, String time) {
                    prefs.setString("title", title);
                    prefs.setString("date", date);
                    prefs.setString("information", information);
                    prefs.setString("time", time);
                   
                    Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => new InfoDetail(),
                    ));

  }
}
