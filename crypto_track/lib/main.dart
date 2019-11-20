



import 'package:crypto_track/CryptoList.dart';
import 'package:crypto_track/Favorites.dart';
import 'package:flutter/material.dart';
import 'package:crypto_track/constants.dart';

void main(){
  runApp(
    new MaterialApp(
      //onGenerateRoute: Router.generateRoute,
      initialRoute: homeRoute,
      routes: {
        homeRoute : (context) => CryptoList(),
        favoritesRoute : (context) => Favorites()
      },
    )
  );
}


