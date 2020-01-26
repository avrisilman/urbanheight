import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbanheight/info/info-detail.dart';
import 'package:urbanheight/service/api.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => new _ProfileState();
}

class _ProfileState extends State<Profile> {
  SharedPreferences prefs;
  List data;
  bool _status = true;
  TextEditingController unitController = new TextEditingController();
  TextEditingController namaController = new TextEditingController();
  TextEditingController ktpController = new TextEditingController();
  TextEditingController hpController = new TextEditingController();
  TextEditingController alamatController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  

  Future<String> makeRequest() async {
    prefs = await SharedPreferences.getInstance();

    String url =
        Api.serviceApi + '/api/menu/' + prefs.getInt("roleId").toString();

    var response = await http.get(Uri.encodeFull(url),
        headers: {'authorization': prefs.getString("token")});

    setState(() {
        unitController.text = prefs.getString("unit");
        namaController.text = prefs.getString("fullName");
        ktpController.text = prefs.getString("noIdentity");
        hpController.text = prefs.getString("handphone");
        alamatController.text = prefs.getString("address");
        emailController.text = prefs.getString("email");

        var extractdata = jsonDecode(response.body);
        data = extractdata['result']['menus'];
    });
  }

  @override
  void initState() {
    this.makeRequest();
  }

  @override
  Widget build(BuildContext context) {
    
    final double circleRadius = 100.0;
    final double circleBorderWidth = 8.0;

    final appbar = AppBar(
      backgroundColor: Colors.white,
      title: new Text(
        'PROFILE',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
    );

    final logos = Container(
        height: 20.0,
        width: 300.0,
        color: Colors.white,
      );

    final logo = Stack(alignment: Alignment.topCenter, children: <Widget>[
      Padding(
        padding: EdgeInsets.only(top: circleRadius / 2.0),
        child: Container(
          //replace this Container with your Card
          color: Colors.blue,
          height: 7.0,
        ),
      ),
      Container(
        width: circleRadius,
        height: circleRadius,
        decoration: ShapeDecoration(shape: CircleBorder(), color: Colors.blue),
        child: Padding(
          padding: EdgeInsets.all(circleBorderWidth),
          child: DecoratedBox(
            decoration: ShapeDecoration(
                shape: CircleBorder(),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      'https://upload.wikimedia.org/wikipedia/commons/a/a0/Bill_Gates_2018.jpg',
                    ))),
          ),
        ),
      ),
    ]);

    final detil = Padding(
        padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Text(
                  'Detail Profile',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            new Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _status ? _getEditIcon() : new Container(),
              ],
            )
          ],
        ));

    final unit = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "Unit",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );

    final unitForm = TextFormField(
      controller: unitController,
      autofocus: false,
      enabled: false, 
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final nama = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "Nama",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );

    final namaForm = TextFormField(
      controller: namaController,
      autofocus: false,
      enabled: false, 
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final ktp = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "Nomor KTP",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );

    final ktpForm = TextFormField(
      controller: ktpController,
      autofocus: false,
      enabled: false, 
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final hp = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "Handphone",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );

    final hpForm = TextFormField(
      controller: hpController,
      autofocus: false,
      enabled: false, 
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final alamat = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "Alamat",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );

    final alamatForm = TextFormField(
      controller: alamatController,
      autofocus: false,
      enabled: false, 
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final email = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "Email",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );

    final emailForm = TextFormField(
      controller: emailController,
      autofocus: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          //padding: EdgeInsets.only(left: 24.0, right: 24.0,top: 20.0),
          children: <Widget>[
            logos,
            logo,
            detil,
            unit,
            unitForm,
            nama,
            namaForm,
            ktp,
            ktpForm,
            hp,
            hpForm,
            alamat,
            alamatForm,
            email,
            emailForm
          ],
        ),
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.blue,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          print("");
        });
      },
    );
  }
}
