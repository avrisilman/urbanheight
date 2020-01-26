import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urbanheight/info/info-detail.dart';
import 'package:urbanheight/service/api.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../mainhome.dart';

class HistoriDetail extends StatefulWidget {
  @override
  _HistoriDetailState createState() => new _HistoriDetailState();
}

class _HistoriDetailState extends State<HistoriDetail> {
  SharedPreferences prefs;
  List data;
  bool _status = true;
  TextEditingController namaBarangController = new TextEditingController();
  TextEditingController kondisiController = new TextEditingController();
  TextEditingController hargaController = new TextEditingController();
  TextEditingController ketController = new TextEditingController();

  Future<String> makeRequest() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      namaBarangController.text = prefs.getString("title");
      kondisiController.text = prefs.getString("conditions");
      hargaController.text = prefs.getString("price");
      ketController.text = prefs.getString("information");
    });
  }

  void onDelete() async {
    var url =
        Api.serviceApi + '/api/market/' + prefs.getInt("marketId").toString();
    final response = await http
        .delete(url, headers: {'authorization': prefs.getString("token")});
    final data = jsonDecode(response.body);
    final message = data['status'];

    setState(() {
      Fluttertoast.showToast(
        msg: message.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );

      if (message == true) {
        Alert(
          context: context,
          type: AlertType.warning,
          title: "DELETE",
          desc: "SUKSES",
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
                "HOME",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new MainHome(),
                ));
              },
              gradient: LinearGradient(colors: [
                Color.fromRGBO(116, 116, 191, 1.0),
                Color.fromRGBO(52, 138, 199, 1.0)
              ]),
            )
          ],
        ).show();
      } else {
        Alert(
          context: context,
          type: AlertType.warning,
          title: "DELETE",
          desc: "Gagal",
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
                "HOME",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new MainHome(),
                ));
              },
              gradient: LinearGradient(colors: [
                Color.fromRGBO(116, 116, 191, 1.0),
                Color.fromRGBO(52, 138, 199, 1.0)
              ]),
            )
          ],
        ).show();
      }
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
            "DETAIL HISTORI",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
         
        );

    final detil = Padding(
        padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 15.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Text(
                  'Edit Informasi',
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

    final barang = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "Nama Barang",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );

    final barangForm = TextFormField(
      controller: namaBarangController,
      autofocus: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );

    final kondisi = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "Kondisi",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );

    final kondisiForm = TextFormField(
      controller: kondisiController,
      autofocus: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );

    final harga = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "Harga",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );

    final hargaForm = TextFormField(
      controller: hargaController,
      autofocus: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );

    final ket = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "Keterangan",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );

    final ketForm = TextFormField(
      controller: ketController,
      autofocus: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar,
      body: Container(
        child: ListView(
          shrinkWrap: true,
          //padding: EdgeInsets.only(left: 24.0, right: 24.0,top: 20.0),
          children: <Widget>[
            detil,
            barang,
            barangForm,
            kondisi,
            kondisiForm,
            harga,
            hargaForm,
            ket,
            ketForm
          ],
        ),
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.delete,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          onDelete();
        });
      },
    );
  }
}
