import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbanheight/buildingmanagement/building.dart';
import 'package:urbanheight/buildingmanagement/service.dart';
import 'package:urbanheight/hobi/hobi-detail.dart';
import 'package:urbanheight/hobi/hobiAdd.dart';
import 'package:urbanheight/market/market-add.dart';
import 'package:urbanheight/numpang/numpang-detail.dart';
import 'package:urbanheight/pinjamalat/pinjamalat.dart';
import 'package:urbanheight/service/api.dart';

class Hobi extends StatefulWidget {
  @override
  _HobiState createState() => new _HobiState();
}

class _HobiState extends State<Hobi> {
  SharedPreferences prefs;
  List data;
  var hobi = '';

  Future<String> makeRequest() async {
    prefs = await SharedPreferences.getInstance();

    String url = Api.serviceApi + '/api/hobi/'+prefs.getInt("subId").toString();

    var response = await http.get(Uri.encodeFull(url),
        headers: {'authorization': prefs.getString("token")});

    setState(() {
      hobi = prefs.getString("hobi");
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
            hobi,
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
                                                data[i]["title"],
                                                data[i]["information"],
                                                data[i]["imgUrl"],
                                                data[i]["date"],
                                                data[i]["time"]
                                                ),
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
                                                            child: Image.memory(
                                                              base64.decode(data[i]["imgUrl"],
                                                              ),
                                                              fit: BoxFit.cover,
                                                             // height: 200.0,
                                                              width: MediaQuery.of(context).size.width,
                                                              alignment: Alignment.topCenter,
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
                                                              data[i]["title"],
                                                              style: TextStyle(
                                                                  color: Colors.blue,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 16.0),
                                                            ),
                                                            SizedBox(height: 8.0),
                                                            Text(data[i]["date"],
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
                
                  _onTileClicked(String title,
                                 String information,
                                 String imgUrl,
                                 String date,
                                 String time) {
              
                    prefs.setString("title", title);
                    prefs.setString("information", information);
                    prefs.setString("imgUrl", imgUrl);
                    prefs.setString("date", date);
                    prefs.setString("time", time);
                
                    Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => new HobiDetail(),
                    ));
                  }
                
                  _onAdd() {
                     Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) => new HobiAdd()),
                        );
                  }
}
