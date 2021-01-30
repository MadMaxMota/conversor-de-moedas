import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const String request = "https://api.hgbrasil.com/finance?format=json&key=ccce24de";

void main() async {
  runApp(MaterialApp(home: Home()));
}

Future<Map> getData() async {
  var response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  double _real;
  double _dolar;
  double _euro;

  TextEditingController _value = TextEditingController();



  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _statusSe1;

  List<DropdownMenuItem<String>> _getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();

    items.add(new DropdownMenuItem(
        value: "Real(R\$)",
        child: new Text('Real',)));

    items.add(new DropdownMenuItem(
        value: "Dolar(US\$)",
        child: new Text('Dolar')));

    items.add(new DropdownMenuItem(
        value: "Euro(€)",
        child: new Text('Euro')));

    return items;
  }

  void changedDropDownItem(String selectedItem) {
    setState(() {
      _statusSe1 = selectedItem;
    });
  }


  @override
  void initState() {
    _dropDownMenuItems = _getDropDownMenuItems();
    _statusSe1 = _dropDownMenuItems[0].value;

    super.initState();
  }

 controllerField(TextEditingController value) {
    if (_statusSe1 == "Real(R\$)") {
      setState(() {
        _real = _value.text as double;
        _dolar = (_real/_dolar);
        _euro = (_real/_euro);


      });
    } else if (_statusSe1 == "Dolar(US\$)") {
      setState(() {
        _dolar = _value.text as double;
        _real = (_dolar*this._dolar);
        _euro = (_dolar*this._dolar/_euro);


      });
    } else if (_statusSe1 == "Euro(€)") {
      setState(() {
        _euro = _value.text as double;
        _real = (_euro*this._euro);
        _dolar = (_euro*this._euro/_dolar);


      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
        title: Text("BullBear"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Opacity(
            opacity: 0.2,
            child: SizedBox.expand(
              child: Image(
                image: AssetImage('assets/image.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          FutureBuilder<Map>(
              future: getData(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:

                    return Center(
                        child: Text(
                          "Carregando Dados...",
                          style:
                          TextStyle(color: Colors.white, fontSize: 25.0),
                          textAlign: TextAlign.center,
                        ));
                  default:
                    if (snapshot.hasError) {
                      return Center(
                          child: Text(
                            "Erro ao Carregar Dados :(",
                            style:
                            TextStyle(color: Colors.white, fontSize: 25.0),
                            textAlign: TextAlign.center,
                          ));
                    } else {
                      _dolar =
                      snapshot.data["results"]["currencies"]["USD"]["buy"];
                      _euro =
                      snapshot.data["results"]["currencies"]["EUR"]["buy"];


                      return SingleChildScrollView(
                        child: Column(

                          children: <Widget>[
                            Container(

                              height: 100,
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: TextField(
                                  controller: _value,
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 17,
                                  ),
                                  decoration: InputDecoration(
                                      labelText: _statusSe1,
                                      labelStyle: TextStyle(
                                          color: Colors.white),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.deepPurple),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)))),

                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 80,
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              20),
                                        ),
                                        color: Colors.deepPurple,
                                        onPressed: () {
                                          setState(() {
                                            print(_real);
                                            print(_dolar);
                                            print(_euro);
                                          });


                                        },
                                        child: Text(
                                          "Converter",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 60,
                                    decoration: (BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.deepPurple,
                                    )),
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: DropdownButton(
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                        dropdownColor: Colors.deepPurple,
                                        value: _statusSe1,
                                        items: _dropDownMenuItems,
                                        onChanged: (value) => changedDropDownItem(value),

                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 40,),
                            Text("$_real", style: TextStyle(color: Colors.white,
                                fontSize: 25)),
                            SizedBox(height: 10,),
                            Text("$_dolar", style: TextStyle(color: Colors.white,
                                fontSize: 25)),
                            SizedBox(height: 10,),
                            Text("$_euro", style: TextStyle(color: Colors.white,
                                fontSize: 25)),


                          ],
                        ),
                      );
                    }
                }
              })
        ],
      ),
    );
  }
}







