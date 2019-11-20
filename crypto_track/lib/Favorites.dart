
import 'package:flutter/material.dart';
import 'package:crypto_track/CryptoList.dart';

class FavoritesState extends State<Favorites>{
  List<Coin> _favorites = List<Coin>();

  @override
  Widget build(BuildContext context) {

    _favorites = ModalRoute.of(context).settings.arguments;

    //Sort the list
    _favorites.sort((coin1, coin2) => coin2.price.compareTo(coin1.price));

    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites"),
      ),
      body: _buildList()
    );
  }


  Widget _buildList(){
    return ListView.builder(
        itemCount: _favorites.length,
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i){
          return _buildRow(_favorites[i]);
        }
    );
  }




  Widget _buildRow(Coin coin){

    return new ListTile(
      title: Text("${coin.name} - Price: ${coin.price.toStringAsFixed(2)} USD"),



    );
  }
}

class Favorites extends StatefulWidget{
  FavoritesState createState() => new FavoritesState();
}