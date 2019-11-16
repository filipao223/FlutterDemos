
import 'package:flutter/material.dart';

class FavoritesState extends State<Favorites>{
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        child: Text("This is a favorites page"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}

class Favorites extends StatefulWidget{
  FavoritesState createState() => new FavoritesState();
}