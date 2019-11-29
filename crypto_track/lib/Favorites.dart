
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_track/DBHandler.dart';
import 'package:crypto_track/constants.dart';
import 'package:flutter/material.dart';
import 'package:crypto_track/CryptoList.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class FavoritesState extends State<Favorites>{
  List<Coin> _favorites = List<Coin>();
  DBHandler dbHandler;
  bool _checkedDatabase = false;


  void _initDBHandler(){
    this.dbHandler = new DBHandler();
  }


  void _getFavoritesFromDatabase() async{
    await dbHandler.init();
    List<Coin> retrievedCoins = await dbHandler.retrieveCoins();

    setState(() {
      _checkedDatabase = true;
      _favorites.addAll(retrievedCoins);
    });
  }



  Future<void> refreshValues() async{
    /*Get the api key from the file*/
    await GlobalConfiguration().loadFromPath("assets/config.json");
    String _apiKey = GlobalConfiguration().get("api_key");

    _favorites.forEach((coin) async{
      /*Make the API request for all coin info*/
      String url = 'https://rest.coinapi.io/v1/exchangerate/${coin.id}/USD?apikey=$_apiKey';
      Response response = await get(url);
      String json = response.body;

      debugPrint(json);

      var jsonData = jsonDecode(json);
      if (jsonData['error'] == null){
        if (double.parse(jsonData['rate'].toString()) != coin.price){
          coin.lastPrice = coin.price;
        }
        setState(() {
          coin.price = double.parse(jsonData['rate'].toString());
        });
      }
      else debugPrint("This asset (${coin.name}) wasn't found");
    });
  }


  @override
  Widget build(BuildContext context) {

    //TODO: Wrap saved coins in a swipe to refresh layout, to update price

    if (_favorites.isEmpty){

      if (_checkedDatabase){

        return Scaffold(
          appBar: AppBar(
            title: Text("Favorites"),
            actions: <Widget>[
              new IconButton(icon: new Icon(Icons.search), onPressed: (){
                Navigator.pushNamed(context, searchRoute, arguments: _favorites);
              })
            ],
          ),
          body: Center(
            child: Text("Nothing here, search for cryptocurrencies"),
          ),
        );
      }

      else {
        setState((){
          _getFavoritesFromDatabase();
        });

        return Scaffold(
          appBar: AppBar(
            title: Text("Favorites"),
            actions: <Widget>[
              new IconButton(icon: new Icon(Icons.search), onPressed: (){
                Navigator.pushNamed(context, searchRoute, arguments: _favorites);
              })
            ],
          ),
          body: Center(
            child: Row(
              children: <Widget>[
                Text('Retrieving from database', textAlign: TextAlign.center),

                new CircularProgressIndicator(),

              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          )
        );
      }
    }
    else{
      return Scaffold(
          appBar: AppBar(
            title: Text("Favorites"),
            actions: <Widget>[
              new IconButton(icon: new Icon(Icons.search), onPressed: (){
                Navigator.pushNamed(context, searchRoute, arguments: _favorites);
              })
            ],
          ),
          body: new Column(
            children: <Widget>[
              new Padding(
                child: new Text(
                  "Swipe down to refresh prices",
                  style: new TextStyle(fontSize:10.0,
                      color: const Color(0xFF000000),
                      fontWeight: FontWeight.w200,
                      fontStyle: FontStyle.italic,
                      fontFamily: "Roboto"),
                ),
                padding: EdgeInsets.only(top: 10.0),

              ),

              new Flexible(
                child: _buildList(),
              )
            ],
          )
      );
    }
  }


  Widget _buildList(){
    /*Debug only*/
    _favorites.forEach((coin) => print("Coin name : ${coin.name}, price : ${coin.price}"));

    return RefreshIndicator(

      onRefresh: (){
        return refreshValues();
      },

      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _favorites.length,
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i){
          return _buildRow(context, _favorites[i]);
        }
      ),
    );
  }




  Widget _buildRow(BuildContext context, Coin coin){
    
    //TODO: Make sure space between current price and price difference is always the same

    double difference = 0.0;
    if (coin != null){
      difference = coin.lastPrice - coin.price;
      difference = difference.abs();
    }

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
                subtitle: RichText(
                  text: TextSpan(
                      text: "Price: ${coin.price.toStringAsFixed(2)} USD   ",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    children: <TextSpan>[
                      TextSpan(
                        text: coin.lastPrice > coin.price ? "-${difference.toStringAsFixed(2)}" : "+${difference.toStringAsFixed(2)}",
                        style: coin.lastPrice > coin.price ? TextStyle(color: Colors.red) : TextStyle(color: Colors.green)
                      )
                    ]
                  ),
                ),
                onTap: () async{
                  final result = await Navigator.pushNamed(context, detailsRoute, arguments: coin);
                  if (result == DELETED_COIN) setState(() {
                    _favorites.remove(coin);
                  });
                },
                trailing: new Icon(Icons.arrow_forward),
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

class Favorites extends StatefulWidget{

  FavoritesState createState(){
    FavoritesState favoritesState =  new FavoritesState();
    // Open the database
    favoritesState._initDBHandler();
    return favoritesState;
  }
}