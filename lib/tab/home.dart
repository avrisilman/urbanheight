import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbanheight/event/event.dart';
import 'package:urbanheight/info/info.dart';
import 'package:urbanheight/login/login.dart';
import 'package:urbanheight/numpang/numpang.dart';
import 'package:urbanheight/service/api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:urbanheight/submenu/submenu.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  SharedPreferences prefs;
  List data;

  String nama = '';

  Future<String> makeRequests() async {
    prefs = await SharedPreferences.getInstance();

    String url =
        Api.serviceApi + '/api/menu/' + prefs.getInt("roleId").toString();

    var response = await http.get(Uri.encodeFull(url),
        headers: {'authorization': prefs.getString("token")});

    setState(() {
      nama = prefs.getString("fullName");
      var extractdata = jsonDecode(response.body);
      data = extractdata['result']['menus'];
    });
  }

  void postPanic() async {
     const url = "tel:+628777543322";   
    if (await canLaunch(url)) {
       await launch(url);
    } else {
      throw 'Could not launch $url';
    }   
  }

  @override
  void initState() {
    this.makeRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 300.0,
          color: Colors.transparent,
          child: Container(
            decoration: new BoxDecoration(
                color: Colors.blue,
                borderRadius: new BorderRadius.only(
                    bottomLeft: const Radius.circular(40.0),
                    bottomRight: const Radius.circular(40.0))),
          ),
        ),
        Container(
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                              width: 20.0,
                              height: 20.0,
                              decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: new NetworkImage(
                                          "https://flaticons.net/gd/makefg.php?i=icons/Application/User-Profile.png&r=255&g=255&b=255")))),
                          Expanded(
                            child: Text(
                              nama,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                 prefs.clear();
                                  Navigator.of(context).push(new MaterialPageRoute(
                                      builder: (BuildContext context) => new Signin(),
                                  ));
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.all(5.0),
                              width: 45.0,
                              height: 45.0,
                              child: Icon(
                                Icons.power_settings_new,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                          margin: const EdgeInsets.all(13.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Welcome to",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              Text(
                                "URBAN HEIGHT",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(""),
                              Text(
                                "Layanan digital untuk Apartement Urban Height",
                                textAlign: TextAlign.left,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Container(
                          margin: const EdgeInsets.only(top: 13.0),
                          height: 30.0,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "   Pilih Menu",
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
                        flex: 4,
                        child: Container(
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4),
                            itemCount: data == null ? 0 : data.length,
                            itemBuilder: (BuildContext context, i) {
                              return Container(
                                  padding: EdgeInsets.all(5.0),
                                  child: new GestureDetector(
                                    onTap: () => _onTileClicked(data[i]["id"]),
                                    //new SubMenu())),
                                    child: Center(
                                      child: GridTile(
                                        footer: Text(
                                          data[i]["nameMenu"],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 8),
                                        ),
                                         child: CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            radius: 80.0,
                                            child: Image.network(
                                              data[i]["urlImage"],
                                              height: 30.0,
                                              width: 30.0,
                                            )),
                                      ),
                                    ),
                                  ));
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  _onTileClicked(int id) {
    prefs.setInt('menuId', id);
    Fluttertoast.showToast(
        msg: id.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );

    if(id == 3){
        prefs.setString("title", "INFO");
    }else if(id == 2){
        prefs.setString("title", "JUAL BELI");
    }else if(id == 4){
        prefs.setString("title", "PINJAM ALAT");
    }else if(id == 5){
        prefs.setString("title", "HOBI");
    }else if(id == 8){
        prefs.setString("title", "BUILDING MANAGEMENT");
    }

    if (id == 6) {
      Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => new Event(),
      ));
    } else if(id == 1){
       Alert(
      context: context,
      type: AlertType.warning,
      title: "PANIC BUTTON",
      desc:
          "Fitur ini hanya untuk dilingkungan Apartement Urban Height Residence tidak berlaku di luar lingkungan Apartement, dan hanya dalam kondisi bahaya.",
      buttons: [
        DialogButton(
          child: Text(
            "CANCEL",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "CALL",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            postPanic();
          },
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    ).show();
    }else if(id == 7){
       Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => new Numpang(),
      ));
    }else if(id == 3){
        Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new Info(),
        ));
    }
    else {
      Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => new SubMenu(),
      ));
    }
   
  }
}
