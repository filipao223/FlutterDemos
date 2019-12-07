

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes/database/DBHandler.dart';
import 'package:notes/dialogs/AddToFolderDialog.dart';
import 'package:notes/models/Commands.dart';
import 'package:notes/models/Folder.dart';
import 'package:notes/models/Note.dart';
import 'package:notes/widgets/SingleNoteCard.dart';

/*Singleton*/
class Controllers{

  static final Controllers instance = Controllers._internal();

  Commands commands = Commands();
  DBHandler dbHandler = DBHandler();

  /*Current data being held*/
  List<Note> noteList, favoriteList;
  List<Folder> folderList;

  factory Controllers(){
    return instance;
  }

  Controllers._internal();

  /*Controller for the popup menus in a note card*/
  void popupMenuController(var value, BuildContext context, SingleNoteCardState originWidget) async{
    await dbHandler.init();

    if (value == commands.deleteNoteVar){
      /*Remove the note form the database*/
      dbHandler.removeNote(commands.currentNote);

      /*Remove it from the displayed list as well*/
      noteList.remove(commands.currentNote);

      //FIXME: Replace with list widget
      originWidget.setState((){});

      Fluttertoast.showToast(msg: "Deleted note", toastLength: Toast.LENGTH_LONG);
    }

    else if (value == commands.addNoteToFolderVar){
      /*Show a dialog that allows the user to choose which folder to add to (or create a new one)*/
      showDialog(
          context: context,
          builder: (context){
            return AddToFolderDialog(folderList, commands.currentNote);
          }
      );
    }

    else{

      /*Change the isSaved property of the note and update its database entry*/
      dbHandler.changeNoteFavoriteStatus(commands.currentNote);

      commands.currentNote.isSaved = !commands.currentNote.isSaved;

      if (favoriteList.contains(commands.currentNote)){
        favoriteList.remove(commands.currentNote);
        Fluttertoast.showToast(msg: "Removed note from favorites", toastLength: Toast.LENGTH_LONG);
      }
      else{
        favoriteList.add(commands.currentNote);
        Fluttertoast.showToast(msg: "Added note to favorites", toastLength: Toast.LENGTH_LONG);
      }

      //FIXME: This rebuild doesn't work right away, only when swiping to another screen
      originWidget.setState((){});
    }
  }

}