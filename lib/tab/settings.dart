import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbanheight/info/info-detail.dart';
import 'package:urbanheight/service/api.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:urbanheight/tab/histori/histori-hobi.dart';
import 'package:urbanheight/tab/histori/histori-numpang.dart';
import 'package:urbanheight/tab/histori/histori-sewa.dart';
import 'package:urbanheight/tab/histori/histori.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => new _SettingState();
}

class _SettingState extends State<Setting> {
  SharedPreferences prefs;
  List data;

  Future<String> makeRequest() async {
    prefs = await SharedPreferences.getInstance();

    String url =
        Api.serviceApi + '/api/histori-menu/' + prefs.getInt("roleId").toString();

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
          title: new Text(
            'HISTORI',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Container(
          child: ListView.builder(
            itemCount: data == null ? 0 : data.length,
            itemBuilder: (BuildContext context, i) {
              return new Container(
                //  padding: const EdgeInsets.all(10.0),
                child: new GestureDetector(
                  onTap: () => _onTileClicked(data[i]["id"]),
                  child: new Card(
                    child: new ListTile(
                      leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Image.network(
                            data[i]["urlImage"],
                            height: 30.0,
                            width: 30.0,
                          )),
                      title: Text(data[i]["nameMenu"]),
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

  _onTileClicked(int menuId) {
    prefs.setInt("menuId", menuId);

   Fluttertoast.showToast(
        msg: menuId.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );

    if(menuId == 1){
      print("panic");
    }else if(menuId == 2){
       Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => new Histori(),
      ));
    }else if(menuId == 4){
       Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new HistoriSewa(),
      ));
    }else if(menuId == 5){
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new HistoriHobi(),
      ));
    }else if(menuId ==7){
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new HistoriNumpang(),
      ));
    }else if(menuId == 8){
      print("service");
    }

  }
}
