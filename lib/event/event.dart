import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbanheight/event/eventadd.dart';
import 'package:urbanheight/service/api.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Event extends StatefulWidget {
  @override
  _EventState createState() => new _EventState();
}

class _EventState extends State<Event> {
  SharedPreferences prefs;
  List data;
  String clock = '';
  String date = '';
  String information = '';
  String status = '';

  Future<String> makeRequest() async {
    prefs = await SharedPreferences.getInstance();

    String url = Api.serviceApi + '/api/event/4';

    var response = await http.get(Uri.encodeFull(url),
        headers: {'authorization': prefs.getString("token")});
    var extractdata = jsonDecode(response.body);
    data = extractdata['result'];
    clock = data[0]["clock"];
    date = data[0]["date"];
    information = data[0]["information"];
    status = data[0]["status"];

    setState(() {});
  }

  @override
  void initState() {
    this.makeRequest();
  }

  @override
  Widget build(BuildContext context) {

    final header = Card(
      color: Colors.blue,
      child: Container(
        padding:
            EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              "Event",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
 
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
                    child: Text("JAM"),
                  ),
                  Container(
                    child: Text(":"),
                  ),
                  Container(
                    child: Text(clock),
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
                    child: Text("Tanggal"),
                  ),
                  Container(
                    child: Text(":"),
                  ),
                  Container(
                    child: Text(date),
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
                    child: Text("Keterangan"),
                  ),
                  Container(
                    child: Text(":"),
                  ),
                  Container(
                    child: Text(information),
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
                    child: Text("Status"),
                  ),
                  Container(
                    child: Text(":"),
                  ),
                  Container(
                    child: Text(status),
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
            'Event',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.add_circle_outline, color: Colors.blue),
                onPressed: () => _onTileClicked(data.length))
                          ],
                        ),
                        backgroundColor: Colors.white,
                        body: Align(
                          alignment: Alignment.topCenter,
                          child: ListView(
                            shrinkWrap: true,
                            padding: EdgeInsets.only(left: 4.0, right: 5.0, top: 5.0),
                            children: <Widget>[header, content],
                          ),
                        ));
                  }
                
                  _onTileClicked(int length) {
                    if (length == 1) {
                       print('object');
                    } else {
                         Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) => new EventAdd(),
                        ));
                    }
                  }
}
