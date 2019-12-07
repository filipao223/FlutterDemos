

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
      //Delete note
      dbHandler.removeNote(commands.currentNote);

      noteList.remove(commands.currentNote);

      //TODO: Not very readable, change this way of triggering a state rebuild
      originWidget.setState((){});

      Fluttertoast.showToast(msg: "Deleted note", toastLength: Toast.LENGTH_LONG);
    }

    else if (value == commands.addNoteToFolderVar){
      //Add note to a folder
      showDialog(
          context: context,
          builder: (context){
            return AddToFolderDialog(folderList, commands.currentNote);
          }
      );
    }

    else{

      dbHandler.changeNoteFavoriteStatus(commands.currentNote);

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