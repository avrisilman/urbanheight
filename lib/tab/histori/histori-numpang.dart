import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbanheight/info/info-detail.dart';
import 'package:urbanheight/service/api.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:urbanheight/tab/histori/histori-detail-numpang.dart';
import 'package:urbanheight/tab/histori/histori-detail.dart';

class HistoriNumpang extends StatefulWidget {
  @override
  _HistoriNumpangState createState() => new _HistoriNumpangState();
}

class _HistoriNumpangState extends State<HistoriNumpang> {
  SharedPreferences prefs;
  List data;

  Future<String> makeRequest() async {
    prefs = await SharedPreferences.getInstance();

    String url =
        Api.serviceApi + '/api/numpang-edit/' + prefs.getInt("usersId").toString();

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
        appBar: AppBar(
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
            "HISTORI NEBENG",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
         
        ),
        body: Container(
          child: ListView.builder(
            itemCount: data == null ? 0 : data.length,
            itemBuilder: (BuildContext context, i) {
              return new Container(
                //  padding: const EdgeInsets.all(10.0),
                child: new GestureDetector(
                  onTap: () => _onTileClicked(
                    data[i]["id"],
                    data[i]["clock"],
                    data[i]["date"],
                    data[i]["harga"],
                    data[i]["goingto"],
                    data[i]["information"]
                  ),
                  child: new Card(
                    child: new ListTile(
                      leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Image.network(
                            "http://urbanheight.000webhostapp.com/numpang.png",
                            height: 30.0,
                            width: 30.0,
                          )),
                      title: Text(data[i]["goingto"]),
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

  _onTileClicked(int numpangId,
                 String clock,
                 String date,
                 String harga,
                 String goingto,
                 String information) {
                   prefs.setInt("numpangId", numpangId);
                   prefs.setString("clock", clock);
                   prefs.setString("date", date);
                   prefs.setString("harga", harga);
                   prefs.setString("goingto", goingto);
                   prefs.setString("information", information);
    Navigator.of(context).push(new MaterialPageRoute(
      builder: (BuildContext context) => new HistoriDetailNumpang(),
    ));
  }
}
