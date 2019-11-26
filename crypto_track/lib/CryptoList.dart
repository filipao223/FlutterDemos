
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_track/DBHandler.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:global_configuration/global_configuration.dart';
import 'dart:convert';

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

    /*Make the API request for all coin info*/
    String url = 'https://rest.coinapi.io/v1/assets?apikey=$_apiKey';
    Response response = await get(url);
    String jsonCoinData = response.body;

    /*Make the API request for all coin pictures*/
    url = 'https://rest.coinapi.io/v1/assets/icons/small?apikey=$_apiKey';
    response = await get(url);
    String jsonCoinPics = response.body;

    print("REQUESTS LIMIT:");
    print(response.headers['X-RateLimit-Limit']);
    debugPrint(response.headers.toString());

    /*Convert the response from a json to a list of Coin*/
    var coinPicsDataMap = jsonDecode(jsonCoinPics);
    var dataMap = jsonDecode(jsonCoinData);
    dataMap.forEach(
            (data) {
          /*Response JSON contains many 'null' values, ensure these don't get added to the list*/
          if (!data['name'].toString().contains("null") && (double.tryParse(data['price_usd'].toString()) != null)) {
            print(data["name"]);
            _coinList.add(new Coin(name: data['name'], id: data['asset_id'], price: double.parse(data['price_usd'].toString()), volumeMonth: double.parse(data['volume_1mth_usd'].toString())));
          }
        }
    );

    /*Iterate over picture url map and save them in respective coin*/
    coinPicsDataMap.forEach(
            (data) {
          String coinId = data['asset_id'];
          String url = data['url'];

          /*Find first coin with the same id (only one should exist)*/
          Coin foundCoin = _coinList.firstWhere((coin) => coin.id.compareTo(coinId) == 0, orElse: () => null);
          if (foundCoin != null) foundCoin.urlPicture = url;
        }
    );

    /*Sort the list by currency price in USD*/
    setState(() {
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
          return buildCard(_coinList[i]);
        }
    );
  }




  Widget buildCard(Coin coin){

    /*Check if user has already saved this coin*/
    var _isSaved = _favorites.firstWhere((coinInList) =>
       coinInList.id == coin.id, orElse: () => null
    );

    return new Card(
      child: new Padding(
          child: new Row(
            children: <Widget>[
              new Container(
                width: 50.0,
                height: 50.0,

                decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    border: new Border.all(
                      color: Colors.white,
                      width: 0.5,
                      style: BorderStyle.solid,
                    ),

                ),

                child: CachedNetworkImage(
                  imageUrl: coin.urlPicture==null ? "" : coin.urlPicture,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),

              new Flexible(
                child: new ListTile(
                  title: Text("${coin.name}"),
                  subtitle: Text("Price: ${coin.price.toStringAsFixed(2)} USD"),
                  trailing: Icon(
                      Icons.add
                  ),
                  onTap: () {
                    setState(() {
                      _favorites.add(coin);

                      print("Adding coin to database");
                      print(dbHandler.addCoin(coin));

                      /*Show a toast when saving the coin*/
                      Fluttertoast.showToast(
                          msg: "Saved ${coin.name}",
                          toastLength: Toast.LENGTH_LONG,
                          timeInSecForIos: 3
                      );
                    });
                  },
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.start,
          ),
          padding: EdgeInsets.only(left: 5.0)
      ),
      margin: EdgeInsets.all(3.0),
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
  String urlPicture = "";

  Coin({this.name, this.id, this.price, this.volumeMonth, this.urlPicture});

  Map<String, dynamic> toMap(){
    return {
      "id" : id,
      "price" : price,
      "volume_month" : volumeMonth,
      "name" : name,
      "url_picture" : urlPicture
    };
  }
}
