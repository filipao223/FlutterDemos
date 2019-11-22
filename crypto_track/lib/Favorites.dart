
import 'package:crypto_track/DBHandler.dart';
import 'package:crypto_track/constants.dart';
import 'package:flutter/material.dart';
import 'package:crypto_track/CryptoList.dart';
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


  void startSearch(BuildContext context) async{
      final _changed = await Navigator.pushNamed(context, searchRoute, arguments: _favorites);

      if (_changed) setState(() {
      });
  }

  @override
  Widget build(BuildContext context) {

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
          body: Row(
            children: <Widget>[
              Expanded(
                child: Text('Retrieving from database', textAlign: TextAlign.center),
              ),
              Expanded(
                child: new CircularProgressIndicator(),
              )
            ],
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
          body: _buildList()
      );
    }
  }


  Widget _buildList(){
    /*Debug only*/
    _favorites.forEach((coin) => print("Coin name : ${coin.name}, price : ${coin.price}"));

    return ListView.builder(
        itemCount: _favorites.length,
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i){
          return _buildRow(context, _favorites[i]);
        }
    );
  }




  Widget _buildRow(BuildContext context, Coin coin){

    return new ListTile(
      title: Text("${coin.name} - Price: ${coin.price.toStringAsFixed(2)} USD"),
      onTap: () async{
        final result = await Navigator.pushNamed(context, detailsRoute, arguments: coin);
        if (result == DELETED_COIN) setState(() {
          _favorites.remove(coin);
        });
      },
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