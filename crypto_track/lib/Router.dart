import 'package:crypto_track/Favorites.dart';
import 'package:flutter/material.dart';
import 'package:crypto_track/Home.dart';
import 'package:crypto_track/constants.dart';


class Router {

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        print("New Home route");
        return MaterialPageRoute(builder: (_) => Home());
      case favoritesRoute:
        print("New Favorites route");
        return MaterialPageRoute(builder: (_) => Favorites());
      default:
        print("New Default route");
        return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                  child: Text('No route defined for ${settings.name}')),
            ));
    }
  }

}