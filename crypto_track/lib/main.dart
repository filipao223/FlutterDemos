



import 'package:crypto_track/CryptoList.dart';
import 'package:crypto_track/Details.dart';
import 'package:crypto_track/Favorites.dart';
import 'package:flutter/material.dart';
import 'package:crypto_track/constants.dart';

void main(){
  runApp(
    new MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.blue,
        ),
        darkTheme: ThemeData(
          primaryColor: Colors.grey,
          brightness: Brightness.dark,
        ),
      //onGenerateRoute: Router.generateRoute,
      initialRoute: homeRoute,
      routes: {
        homeRoute : (context) => Favorites(),
        searchRoute : (context) => CryptoList(),
        detailsRoute : (context) => Details()
      }
    )
  );
}


