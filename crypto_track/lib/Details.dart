


import 'package:crypto_track/DBHandler.dart';
import 'package:crypto_track/constants.dart';
import 'package:flutter/material.dart';
import 'package:crypto_track/CryptoList.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DetailsState extends State<Details>{
  Coin _coin;
  DBHandler dbHandler;


  void initDBHandler() {
    dbHandler = new DBHandler();
    dbHandler.init();
  }

  @override
  Widget build(BuildContext context) {
    _coin = ModalRoute.of(context).settings.arguments;

    if (_coin == null){
      return Scaffold(
        appBar: AppBar(
          title: Text("Details"),
        ),
        body: Center(
          child: Text("Error, coin is null"),
        ),
      );
    }
    else{
      return Scaffold(

        appBar: AppBar(
          title: Text("${_coin.name}"),
          actions: <Widget>[
            new IconButton(icon: Icon(Icons.delete), onPressed: (){
              /*Remove coin from database*/
              dbHandler.removeCoin(_coin);

              /*Pop with deleted coin return value*/
              Navigator.pop(context, DELETED_COIN);
            })
          ],
        ),

        body: new Container(
          child:
          new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Text(
                  "${_coin.name}",
                  style: new TextStyle(fontSize:36.0,
                      color: const Color(0xFF000000),
                      fontWeight: FontWeight.w200,
                      fontFamily: "Roboto"),
                ),

                new Text(
                  "Price: ${_coin.price.toStringAsFixed(2)}",
                  style: new TextStyle(fontSize:12.0,
                      color: const Color(0xFF000000),
                      fontWeight: FontWeight.w200,
                      fontFamily: "Roboto"),
                )
              ]

          ),

          padding: const EdgeInsets.all(0.0),
          alignment: Alignment.center,
        ),
      );
    }
  }
}



class Details extends StatefulWidget{

  DetailsState createState(){
    DetailsState detailsState = new DetailsState();
    detailsState.initDBHandler();
    return detailsState;
  }
}