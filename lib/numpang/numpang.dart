import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbanheight/buildingmanagement/building.dart';
import 'package:urbanheight/buildingmanagement/service.dart';
import 'package:urbanheight/numpang/numpang-add.dart';
import 'package:urbanheight/numpang/numpang-detail.dart';
import 'package:urbanheight/pinjamalat/pinjamalat.dart';
import 'package:urbanheight/service/api.dart';

class Numpang extends StatefulWidget {
  @override
  _NumpangState createState() => new _NumpangState();
}

class _NumpangState extends State<Numpang> {
  SharedPreferences prefs;
  List data;

  Future<String> makeRequest() async {
    prefs = await SharedPreferences.getInstance();

    String url = Api.serviceApi + '/api/numpang';

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
            color: Colors.blue,
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: new Text(
            'NEBENG',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.add_circle_outline, color: Colors.blue),
                onPressed: () => _onAdd())
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
                    "   Pilih Tujuan anda",
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
                flex: 12,
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemCount: data == null ? 0 : data.length,
                      itemBuilder: (BuildContext context, i) {
                        //if (index < 50)
                        return Container(
                          decoration: new BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: new BorderRadius.only()),
                          // padding: EdgeInsets.all(20.0),
                          child: new GestureDetector(
                            onTap: () => _onTileClicked(
                                data[i]["id"],
                                data[i]["usersId"],
                                data[i]["goingto"],
                                data[i]["clock"],
                                data[i]["date"],
                                data[i]["harga"],
                                data[i]["information"]),
                            child: Center(
                                child: Column(
                              children: <Widget>[
                                Card(
                                  clipBehavior: Clip.antiAlias,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      AspectRatio(
                                        aspectRatio: 18.0 / 11.0,
                                        child: CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            // radius: 80.0,
                                            child: Image.network(
                                              //data[i]["urlImageSub"],
                                              'https://cdn.iconscout.com/icon/free/png-256/car-location-find-navigate-gps-location-29571.png',
                                            )),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            16.0, 12.0, 16.0, 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              data[i]["goingto"],
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0),
                                            ),
                                            SizedBox(height: 8.0),
                                            Text("Jam : " + data[i]["clock"],
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12.0)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )),
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

  _onTileClicked(int idNumpang,
                 int usersIdNumpang,
                 String goingto,
                 String clock,
                 String date,
                 String harga,
                 String information) {

    prefs.setInt("idNumpang", idNumpang);
    prefs.setInt("usersIdNumpang", usersIdNumpang);
    prefs.setString("goingto", goingto);
    prefs.setString("clock", clock);
    prefs.setString("date", date);
    prefs.setString("harga", harga);
    prefs.setString("information", information);

    Navigator.of(context).push(new MaterialPageRoute(
      builder: (BuildContext context) => new NumpangDetail(),
    ));
  }
   _onAdd() {
                     Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) => new NumpangAdd(),
                        ));
                  }
}
