

import 'package:flutter/material.dart';
import 'package:notes/controllers/Controllers.dart';
import 'package:notes/database/DBHandler.dart';
import 'package:notes/screens/Folders.dart';
import 'package:notes/screens/SingleNotes.dart';
import 'package:notes/models/Note.dart';
import 'package:notes/constants.dart';

import '../models/Folder.dart';


class MainScreenState extends State<MainScreen>{
  
  List<Note> noteList, favoriteList;
  List<Folder> folderList;
  int selectedBottomNavItem = 0;
  PageController pageController = PageController();
  DBHandler dbHandler = DBHandler();
  bool checkedDatabase = false;
  Controllers controllers = Controllers();



  void onItemTapped(int index){
    pageController.animateToPage(index, duration: Duration(milliseconds: 250), curve: Curves.ease);
  }



  void onPageChanged(int page){
    setState(() {
      selectedBottomNavItem = page;
    });
  }



  void getNotesFromDatabase() async{
    await dbHandler.init();
    if (noteList == null) noteList = List<Note>();
    if (folderList == null) folderList = List<Folder>();
    if (favoriteList == null) favoriteList = List<Note>();

    /*Also update the lists in Controller*/
    controllers.noteList = noteList;
    controllers.favoriteList = favoriteList;
    controllers.folderList = folderList;

    List<Note> retrievedNotes = await dbHandler.retrieveNotes();
    List<Folder> retrievedFolders = await dbHandler.retrieveFolders();

    //TODO: Fill each folder's note list with correct notes

    noteList.addAll(retrievedNotes);
    folderList.addAll(retrievedFolders);

    /*Check which notes are saved and if they belong to a folder*/
    noteList.forEach((note){
      if (note.isSaved) favoriteList.add(note);
      if (note.folderId != -1){
        Folder folder = folderList.firstWhere((folder) => folder.folderId == note.folderId, orElse: () => null);
        if (folder != null){
          folder.noteList.add(note);
        }
      }
    });

    /**/

    noteList.sort((note1, note2)=>note2.dateCreated.compareTo(note1.dateCreated));

    setState(() {
      checkedDatabase = true;
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

      //FIXME: Insertion problem has returned, wrong widgets when inserting at first index
      floatingActionButton: FloatingActionButton(
        key: MainScreen.addNoteFabKey,
        child: Icon(Icons.add),
        onPressed: () async{
          /*Open the AddNote page where a new note can be created, and add it to the list if created*/
          var result = await Navigator.pushNamed(context, addNoteRoute);
          if (result != null && result is Note){
            setState(() {
              noteList.insert(0, result);
            });
          }
        },
      ),
    );
  }


  Widget buildBody(){

    if (checkedDatabase){
      return PageView(
        controller: pageController,
        children: <Widget>[

          SingleNotes(noteList, folderList, favoriteList),
          Folders(folderList),
          SingleNotes(favoriteList, folderList, favoriteList)

        ],

        onPageChanged: onPageChanged,
      );
    }

    else{
      getNotesFromDatabase();

      return PageView(
        controller: pageController,
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



class MainScreen extends StatefulWidget{

  static const addNoteFabKey = Key("addNoteFabKey");

  MainScreenState createState(){
    MainScreenState homeState = new MainScreenState();
    //homeState.createPlaceholderNotes();
    return homeState;
  }
}