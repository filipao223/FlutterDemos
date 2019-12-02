


import 'package:flutter/material.dart';
import 'Note.dart';

class SavedState extends State<Saved>{

  List<Note> noteList;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Text("Saved"),
    );
  }
}



class Saved extends StatefulWidget{

  SavedState createState(){
    SavedState savedState = SavedState();

    return savedState;
  }
}