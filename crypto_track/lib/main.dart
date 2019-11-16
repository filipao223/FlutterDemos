import 'package:flutter/material.dart';
import 'package:crypto_track/Router.dart';
import 'package:crypto_track/constants.dart';

void main(){
  runApp(
    new MaterialApp(
      onGenerateRoute: Router.generateRoute,
      initialRoute: homeRoute,
    )
  );
}


