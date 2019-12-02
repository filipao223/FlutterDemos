

import 'package:flutter/material.dart';
import 'package:notes/DBHandler.dart';
import 'package:notes/Folders.dart';
import 'package:notes/Saved.dart';
import 'package:notes/SingleNotes.dart';
import 'package:notes/Note.dart';
import 'package:notes/constants.dart';

import 'Folder.dart';

class BottomNavState extends State<BottomNav>{
  
  List<Note> noteList;
  List<Folder> folderList;
  int selectedBottomNavItem = 0;
  PageController _pageController = PageController();
  DBHandler dbHandler = DBHandler();
  bool checkedDatabase = false;



  void onItemTapped(int index){
    _pageController.animateToPage(index, duration: Duration(milliseconds: 250), curve: Curves.ease);
  }



  void onPageChanged(int page){
    setState(() {
      selectedBottomNavItem = page;
    });
  }



  //TODO: Add folder retrieval
  void getNotesFromDatabase() async{
    await dbHandler.init();
    if (noteList == null) noteList = List<Note>();
    if (folderList == null) folderList = List<Folder>();

    List<Note> retrievedNotes = await dbHandler.retrieveNotes();
    //List<Folder> retrievedFolders = await dbHandler.retrieveFolders():

    setState(() {
      checkedDatabase = true;
      noteList.addAll(retrievedNotes);
      //folderList.addAll(retrievedFolders);
    });
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
      ),
      body: buildBody(),

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

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          if (selectedBottomNavItem == 0) Navigator.pushNamed(context, addNoteRoute).then((_){
            setState(() {
              //TODO: Add the new note to the list, without querying the database again
            });
          });
          else if (selectedBottomNavItem == 1) Navigator.pushNamed(context, addNoteRoute); //TODO: Change this route
        },
      ),
    );
  }


  Widget buildBody(){

    if (checkedDatabase){
      return PageView(
        controller: _pageController,
        children: <Widget>[

          SingleNotes(noteList),
          Folders(folderList),
          Saved()

        ],

        onPageChanged: onPageChanged,
      );
    }

    else{
      getNotesFromDatabase();

      return PageView(
        controller: _pageController,
        children: <Widget>[

          Row(mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Reading from database"),
              CircularProgressIndicator()
          ],),

          Row(mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Reading from database"),
              CircularProgressIndicator()
          ],),

          Row(mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Reading from database"),
              CircularProgressIndicator()
          ],)

        ],

        onPageChanged: onPageChanged,
      );
    }

  }


}



class BottomNav extends StatefulWidget{

  BottomNavState createState(){
    BottomNavState homeState = new BottomNavState();
    //homeState.createPlaceholderNotes();
    return homeState;
  }
}