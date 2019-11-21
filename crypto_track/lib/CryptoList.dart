
import 'package:crypto_track/DBHandler.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:global_configuration/global_configuration.dart';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class CryptoListState extends State<CryptoList> {
  String _apiKey = "null";
  List<Coin> _coinList = List<Coin>();
  List<Coin> _favorites;
  DBHandler dbHandler;

  void _initDBHandler(){
    this.dbHandler = new DBHandler();
    dbHandler.init();
  }

  void _getCryptoNames() async {
    /*Get the api key from the file*/
    await GlobalConfiguration().loadFromPath("assets/config.json");
    _apiKey = GlobalConfiguration().get("api_key");

    /*Make the API request*/
    String url = 'https://rest.coinapi.io/v1/assets?apikey=$_apiKey';
    Response response = await get(url);
    int statusCode = response.statusCode;
    Map<String, String> headers = response.headers;
    String contentType = headers['content-type'];
    String json = response.body;

    /*Convert the response from a json to a list of Coin*/
    var dataMap = jsonDecode(json);
    setState(() {
      dataMap.forEach(
              (data) {
            /*Response JSON contains many 'null' values, ensure these don't get added to the list*/
            if (!data['name'].toString().contains("null") && (double.tryParse(data['price_usd'].toString()) != null)) {
              print(data["name"]);
              _coinList.add(new Coin(name: data['name'], id: data['asset_id'], price: double.parse(data['price_usd'].toString()), volumeMonth: double.parse(data['volume_1mth_usd'].toString())));
            }
          }
      );

      /*Sort the list by currency price in USD*/
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
      _favorites = ModalRoute.of(context).settings.arguments;

      return new Scaffold(
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

    /*Check if user has already saved this coin*/
    var _isSaved = _favorites.firstWhere((coinInList) =>
       coinInList.id == coin.id, orElse: () => null
    );

    return new ListTile(
      title: Text("${coin.name} - Price: ${coin.price.toStringAsFixed(2)} USD"),
      trailing: Icon(
        _isSaved!=null ? Icons.favorite : Icons.favorite_border,
        color: _isSaved!=null ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (_isSaved!=null){
            _favorites.remove(coin);
            _isSaved = null;

            //TODO: Database remove
          }
          else{
            _favorites.add(coin);
            _isSaved = coin;

            //TODO: Database add
            print("CALLED ADDCOIN TO DATABASE");
            print(dbHandler.addCoin(coin));
          }
        });
      },
    );
  }

}

class CryptoList extends StatefulWidget{
  @override
  CryptoListState createState(){
    CryptoListState cryptoListState = new CryptoListState();
    cryptoListState._initDBHandler();
    cryptoListState._getCryptoNames();
    return cryptoListState;
  }
}


class Coin{
  final String name;
  final String id;
  final double price;
  final double volumeMonth;

  Coin({this.name, this.id, this.price, this.volumeMonth});

  Map<String, dynamic> toMap(){
    return {
      "id" : id,
      "price" : price,
      "volume_month" : volumeMonth,
      "name" : name
    };
  }
}
