

import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:notes/dialogs/AddToFolderDialog.dart';
import 'package:notes/database/DBHandler.dart';
import 'package:notes/models/Commands.dart';
import 'package:notes/models/Note.dart';
import 'package:notes/widgets/NoteLanguage.dart';
import 'package:notes/widgets/SingleNoteCard.dart';
import '../models/Folder.dart';

class SingleNotesState extends State<SingleNotes>{

  List<Note> noteList, favoriteList;
  List<Folder> folderList;
  DBHandler dbHandler = DBHandler();
  Commands commands = Commands();

  SingleNotesState(List<Note> listNotes, List<Folder> listFolders, List<Note> listFavorites){this.noteList = listNotes; this.folderList = listFolders; this.favoriteList = listFavorites;}


  //TODO: Handle 'add note to a folder'



  @override
  void initState() {
    dbHandler.init();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return buildList();
  }


  Widget buildList(){

    if (noteList.isEmpty){
      return Center(
        child: Text(
          "No notes here",
          style: TextStyle(
            fontSize: 12,
            fontStyle: FontStyle.italic
          ),
        ),
      );
    }

    else{
      return ListView.builder(
        padding: const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 48),
        itemCount: noteList.length,
        itemBuilder: (context, i){
          return buildItem(noteList[i]);
        },
      );
    }
  }




  Widget buildItem(Note note){

    return SingleNoteCard(
      key: Key(note.noteId.toString()),
      note: note,
      noteList: noteList,
      folderList: folderList,
      favoriteList: favoriteList,
      rootList: this);
  }
}


class SingleNotes extends StatefulWidget{

  List<Note> noteList, favoriteList;
  List<Folder> folderList;

  SingleNotes(List<Note> listNotes, List<Folder> listFolders, List<Note> listFavorites){this.noteList = listNotes; this.folderList = listFolders; this.favoriteList = listFavorites;}

  SingleNotesState createState(){
    SingleNotesState singleNotesState = SingleNotesState(noteList, folderList, favoriteList);
    /*Do something*/
    //singleNotesState.createPlaceholderNotes();
    return singleNotesState;
  }
}