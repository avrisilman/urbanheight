import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbanheight/buildingmanagement/building.dart';
import 'package:urbanheight/buildingmanagement/service.dart';
import 'package:urbanheight/hobi/hobi.dart';
import 'package:urbanheight/market/market.dart';
import 'package:urbanheight/pinjamalat/pinjamalat.dart';
import 'package:urbanheight/service/api.dart';

class SubMenu extends StatefulWidget {
  static String tag = 'submenu';

  @override
  _SubMenuState createState() => new _SubMenuState();
}

class _SubMenuState extends State<SubMenu> {
  SharedPreferences prefs;
  List data;
  var title = '';

  Future<String> makeRequest() async {
    prefs = await SharedPreferences.getInstance();

    String url =
        Api.serviceApi + '/api/submenu/' + prefs.getInt("menuId").toString();

    var response = await http.get(Uri.encodeFull(url),
        headers: {'authorization': prefs.getString("token")});

    setState(() {
      title = prefs.getString("title");
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
            title,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
         
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
                              "   Pilih Kategori",
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
                flex: 9,
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemCount: data == null ? 0 : data.length,
                      itemBuilder: (BuildContext context, i) {
                        //if (index < 50)
                        return Container(
                           decoration: new BoxDecoration(
                color: Colors.blue[50],
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(8.0),
                    topRight: const Radius.circular(8.0),
                    bottomLeft: const Radius.circular(8.0),
                    bottomRight: const Radius.circular(8.0))),
                          padding: EdgeInsets.all(20.0),
                          child: new GestureDetector(
                            onTap: () => _onTileClicked(data[i]["id"]),
                            child: Center(
                              child: GridTile(
                                footer: Text(
                                  data[i]["nameSubMenu"],
                                  textAlign: TextAlign.center, style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold),
                                ),
                                header: Text(
                                  '',
                                  textAlign: TextAlign.center,
                                ),
                               child: CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            radius: 80.0,
                                            child: Image.network(
                                              data[i]["urlImageSub"],
                                              height: 30.0,
                                              width: 30.0,
                                            )),
                              ),
                            ),
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

  _onTileClicked(int subId) {
    prefs.setInt('subId', subId);
    Fluttertoast.showToast(
        msg: subId.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );

    if(subId == 1){
      prefs.setString("market", "KULINER");
    }else if(subId == 2){
      prefs.setString("market", "PHONE & TABLET");
    }else if(subId == 3){
      prefs.setString("market", "ELEKTRONIK");
    }else if(subId == 4){
      prefs.setString("market", "FASHION");
    }else if(subId == 5){
      prefs.setString("market", "KENDARAAN");
    }else if(subId == 6){
      prefs.setString("market", "IBU BAYI & ANAK");
    }else if(subId == 7){
      prefs.setString("market", "MUSIK");
    }else if(subId == 8){
      prefs.setString("market", "GAME & APLIKASI");
    }else if(subId == 9){
      prefs.setString("market", "INTERIOR");
    }else if(subId == 10){
      prefs.setString("market", "OTOMOTIF");
    }else if(subId == 11){
      prefs.setString("market", "SPORT");
    }else if(subId == 12){
      prefs.setString("market", "KECANTIKAN");
    }else if(subId == 13){
      prefs.setString("market", "BIMBEL");
    }else if(subId == 14){
      prefs.setString("market", "INSTRUKTUR");
    }else if(subId == 15){
      prefs.setString("market", "MUSIC COURSE");
    }else if(subId == 16){
      prefs.setString("market", "TRAVEL");
    }else if(subId == 17){
      prefs.setString("market", "ENGLISH COURSE");
    }else if(subId == 18){
      prefs.setString("market", "APARTEMENT");
    }else if(subId == 19){
      prefs.setString("hobi", "OTOMOTIF");
    }else if(subId == 20){
      prefs.setString("hobi", "COFFE & TEA");
    }else if(subId == 21){
      prefs.setString("hobi", "FASHION");
    }else if(subId == 22){
      prefs.setString("hobi", "FILM ANIMASI & VIDEO");
    }else if(subId == 23){
      prefs.setString("hobi", "SENI KRIYA");
    }else if(subId == 24){
      prefs.setString("hobi", "APLIKASI & GAME");
    }else if(subId == 25){
      prefs.setString("hobi", "INTERIOR");
    }else if(subId == 26){
      prefs.setString("hobi", "MUSIK");
    }else if(subId == 27){
      prefs.setString("hobi", "FOTOGRAFI");
    }else if(subId == 28){
      prefs.setString("hobi", "KULINER");
    }else if(subId == 29){
      prefs.setString("hobi", "SENI RUPA");
    }else if(subId == 30){
      prefs.setString("hobi", "DRONE");
    }else if(subId == 31){
      prefs.setString("hobi", "SENI PERTUNJUKAN");
    }else if(subId == 32){
      prefs.setString("hobi", "GYM & DANCE");
    }else if(subId == 33){
      prefs.setString("hobi", "TRAVEL");
    }else if(subId == 34){
      prefs.setString("hobi", "SPORT");
    }else if(subId == 35){
      prefs.setString("hobi", "TANAMAN");
    }else if(subId == 36){
      prefs.setString("hobi", "KOMIK");
    }else if(subId == 37){
      prefs.setString("sewa", "OBENG");
    }else if(subId == 38){
      prefs.setString("sewa", "TANG");
    }else if(subId == 39){
      prefs.setString("sewa", "KUNCI INGGRIS");
    }else if(subId == 40){
      prefs.setString("sewa", "GERGAJI");
    }else if(subId == 41){
      prefs.setString("sewa", "MARTIL");
    }else if(subId == 42){
      prefs.setString("sewa", "BOR");
    }else if(subId == 43){
      prefs.setString("sewa", "KUNCI RING");
    }else if(subId == 44){
      prefs.setString("sewa", "METERAN");
    }else if(subId == 45){
      prefs.setString("sewa", "TANGGA");
    }else if(subId == 46){
      prefs.setString("sewa", "KUNCI SET BOX");
    }

    if (subId == 48) {
       Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new Services(),
      ));
    } else if((subId >= 37) && (subId <= 46)){
        Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new PinjamAlat(),
        ));
    } else if((subId >= 47) && (subId <= 47)){
        // Navigator.of(context).push(new MaterialPageRoute(
        //   builder: (BuildContext context) => new Building(),
        // ));
        print('');
    } else if ((subId >= 1) && (subId <= 18)){
        Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new Market(),
        ));
    } else if ((subId >= 19) && (subId <= 36)){
        Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new Hobi(),
        ));
    }
   
  }
}
