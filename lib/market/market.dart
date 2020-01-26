import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbanheight/buildingmanagement/building.dart';
import 'package:urbanheight/buildingmanagement/service.dart';
import 'package:urbanheight/market/market-add.dart';
import 'package:urbanheight/market/market-detail.dart';
import 'package:urbanheight/numpang/numpang-detail.dart';
import 'package:urbanheight/pinjamalat/pinjamalat.dart';
import 'package:urbanheight/service/api.dart';

class Market extends StatefulWidget {
  @override
  _MarketState createState() => new _MarketState();
}

class _MarketState extends State<Market> {
  SharedPreferences prefs;
  List data;
  var market ='';

  Future<String> makeRequest() async {
    prefs = await SharedPreferences.getInstance();

    String url = Api.serviceApi + '/api/market/'+prefs.getInt("subId").toString();

    var response = await http.get(Uri.encodeFull(url),
        headers: {'authorization': prefs.getString("token")});

    setState(() {
      market = prefs.getString("market");
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
            market,
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
                                                data[i]["conditions"],
                                                data[i]["date"],
                                                data[i]["imgUrl"],
                                                data[i]["information"],
                                                data[i]["price"],
                                                data[i]["status"],
                                                data[i]["time"],
                                                data[i]["handphone"],
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
                                                            Text(data[i]["price"],
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
                
                  _onTileClicked(
                     String title,
                     String conditions,
                     String date,
                     String imgUrl,
                     String information,
                     String price,
                     String status,
                     String time,
                     String hp,
                    ) {

                    prefs.setString("title", title);
                    prefs.setString("conditions", conditions);
                    prefs.setString("date", date);
                    prefs.setString("imgUrl", imgUrl);
                    prefs.setString("information", information);
                    prefs.setString("price", price);
                    prefs.setString("status", status);
                    prefs.setString("time", time);
                    prefs.setString("hp", hp);

                    Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => new MarketDetail(),
                    ));
                    }
                
                  _onAdd() {
                     Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) => new MarketAdd(),
                        ));
                  }
}
