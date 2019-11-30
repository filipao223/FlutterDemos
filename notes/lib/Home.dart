

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes/Folders.dart';
import 'package:notes/Saved.dart';
import 'package:notes/SingleNotes.dart';

class HomeState extends State<Home>{
  
  List<Note> noteList;
  int selectedBottomNavItem = 0;
  PageController _pageController = PageController();



  void onItemTapped(int index){
    _pageController.animateToPage(index, duration: Duration(milliseconds: 250), curve: Curves.ease);
  }



  void onPageChanged(int page){
    setState(() {
      selectedBottomNavItem = page;
    });
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
      ),
      body: PageView(
        controller: _pageController,
        children: <Widget>[

          SingleNotes().createState().build(context),
          Folders().createState().build(context),
          Saved().createState().build(context)

        ],

        onPageChanged: onPageChanged,
      ),

      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_drive_file),
            title: Text("Notes")
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            title: Text("Folders")
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            title: Text("Favorites")
          ),
        ],

        currentIndex: selectedBottomNavItem,
        onTap: onItemTapped,
      ),
    );
  }



}



class Home extends StatefulWidget{

  HomeState createState(){
    HomeState homeState = new HomeState();
    //homeState.createPlaceholderNotes();
    return homeState;
  }
}



class Note{
  final int noteId;
  String noteTitle;
  String content;
  final DateTime dateCreated;
  DateTime dateLastEdited;

  Note({this.noteId, this.noteTitle, this.content, this.dateCreated, this.dateLastEdited});
}