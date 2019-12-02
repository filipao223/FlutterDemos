

import 'package:flutter/material.dart';
import 'package:notes/DBHandler.dart';
import 'package:notes/Folders.dart';
import 'package:notes/Saved.dart';
import 'package:notes/SingleNotes.dart';
import 'package:notes/Note.dart';

class BottomNavState extends State<BottomNav>{
  
  List<Note> noteList;
  int selectedBottomNavItem = 0;
  PageController _pageController = PageController();
  DBHandler dbHandler;
  bool checkedDatabase = false;



  void onItemTapped(int index){
    _pageController.animateToPage(index, duration: Duration(milliseconds: 250), curve: Curves.ease);
  }



  void onPageChanged(int page){
    setState(() {
      selectedBottomNavItem = page;
    });
  }


  void initDBHandler(){
    this.dbHandler = DBHandler();
  }



  void getNotesFromDatabase() async{
    await dbHandler.init();
    if (noteList == null) noteList = new List<Note>();

    List<Note> retrievedNotes = await dbHandler.retrieveNotes();

    setState(() {
      checkedDatabase = true;
      noteList.addAll(retrievedNotes);
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

          SingleNotes(),
          Folders(),
          Saved()

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



class BottomNav extends StatefulWidget{

  BottomNavState createState(){
    BottomNavState homeState = new BottomNavState();
    //homeState.createPlaceholderNotes();
    return homeState;
  }
}