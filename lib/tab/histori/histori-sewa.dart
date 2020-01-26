import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbanheight/info/info-detail.dart';
import 'package:urbanheight/service/api.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:urbanheight/tab/histori/histori-detail-sewa.dart';
import 'package:urbanheight/tab/histori/histori-detail.dart';

class HistoriSewa extends StatefulWidget {
  @override
  _HistoriSewaState createState() => new _HistoriSewaState();
}

class _HistoriSewaState extends State<HistoriSewa> {
  SharedPreferences prefs;
  List data;

  Future<String> makeRequest() async {
    prefs = await SharedPreferences.getInstance();

    String url =
        Api.serviceApi + '/api/sewa-edit/' + prefs.getInt("usersId").toString()+"/"+prefs.getInt("menuId").toString();

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
            "HISTORI SEWA",
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
                    data[i]["title"],
                    data[i]["lamaPinjam"],
                    data[i]["price"],
                    data[i]["information"]
                  ),
                  child: new Card(
                    child: new ListTile(
                      leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Image.network(
                            "http://urbanheight.000webhostapp.com/pinjamalat.png",
                            height: 30.0,
                            width: 30.0,
                          )),
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

  _onTileClicked(int sewaId,
                 String title,
                 String lamaPinjam,
                 String price,
                 String information) {
                   prefs.setInt("sewaId", sewaId);
                   prefs.setString("title", title);
                   prefs.setString("lamaPinjam", lamaPinjam);
                   prefs.setString("price", price);
                   prefs.setString("information", information);
    Navigator.of(context).push(new MaterialPageRoute(
      builder: (BuildContext context) => new HistoriDetailSewa(),
    ));
  }
}
