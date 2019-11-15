import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:global_configuration/global_configuration.dart';
import 'dart:developer';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: CryptoList()
    );
  }
}

class CryptoListState extends State<CryptoList> {
  final _cryptoList = List<String>();
  String _apiKey = "null";
  String _coinName = "null";
  List<Coin> _coinList = List<Coin>();

  void _getCryptoNames() async {
    await GlobalConfiguration().loadFromPath("assets/config.json");

    _apiKey = GlobalConfiguration().get("api_key");

    // make GET request
    String url = 'https://rest.coinapi.io/v1/assets?apikey=$_apiKey';
    Response response = await get(url);
    // sample info available in response

    int statusCode = response.statusCode;
    Map<String, String> headers = response.headers;
    String contentType = headers['content-type'];
    String json = response.body;
    // TODO convert json to object...
    var dataMap = jsonDecode(json);
    setState(() {
      dataMap.forEach(
              (data) => {
                if (!data['name'].toString().contains("null") && (double.tryParse(data['price_usd'].toString()) != null)) {
                  print(data["name"]),
                  _coinList.add(new Coin(data['name'], data['asset_id'], double.parse(data['price_usd'].toString()), double.parse(data['volume_1mth_usd'].toString())))
                }
              }
      );

      /*Sort the list by volume in a month*/
      _coinList.sort((coin1, coin2) => coin2.price.compareTo(coin1.price));
    });
  }

  @override
  Widget build(BuildContext context){
    if (_coinList.isEmpty){
      return Scaffold(
          appBar: AppBar(
            title: Text("CryptoTrack"),
          ),
          body: Center(
            child: Text("Getting info from API"),
          )

      );
    }
    else{
      return Scaffold(
          appBar: AppBar(
            title: Text("CryptoTrack"),
          ),
          body: _buildList()

      );
    }
  }

  Widget _buildList(){
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i){
        return _buildRow(_coinList[i]);
      }
    );
  }

  Widget _buildRow(Coin coin){
    return ListTile(
      title: Text("${coin.name} - Price: ${coin.price.toStringAsFixed(2)} USD"),
    );
  }

}

class CryptoList extends StatefulWidget{
  @override
  CryptoListState createState(){
    CryptoListState cryptoListState = new CryptoListState();
    cryptoListState._getCryptoNames();
    return cryptoListState;
  }
}


class Coin{
  final String name;
  final String id;
  final double price;
  final double volume_month;

  Coin(this.name, this.id, this.price, this.volume_month);
}
