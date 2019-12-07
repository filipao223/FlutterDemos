import 'package:flutter/material.dart';
import 'package:notes/screens/AddNote.dart';
import 'package:notes/constants.dart';
import 'package:notes/screens/MainScreen.dart';

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
            homeRoute : (context) => MainScreen(),
            addNoteRoute : (context) => AddNote(),
          },


      )
  );
}

