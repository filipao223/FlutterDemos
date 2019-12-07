

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:notes/dialogs/AddToFolderDialog.dart';
import 'package:notes/database/DBHandler.dart';
import 'package:notes/models/Note.dart';
import 'package:notes/widgets/NoteLanguage.dart';
import '../models/Folder.dart';

class SingleNotesState extends State<SingleNotes>{

  List<Note> noteList, favoriteList;
  List<Folder> folderList;
  DBHandler dbHandler = DBHandler();
  Commands commands = Commands();

  SingleNotesState(List<Note> listNotes, List<Folder> listFolders, List<Note> listFavorites){this.noteList = listNotes; this.folderList = listFolders; this.favoriteList = listFavorites;}


  void createPlaceholderNotes(){
    noteList = new List<Note>();

    noteList.add(new Note(noteId: 1, noteTitle: "title1", noteContent: "test", dateCreated: DateTime.now(), dateLastEdited: DateTime.now()));
    noteList.add(new Note(noteId: 2, noteTitle: "title2", noteContent: "test", dateCreated: DateTime.now(), dateLastEdited: DateTime.now()));
    noteList.add(new Note(noteId: 3, noteTitle: "title3", noteContent: "test", dateCreated: DateTime.now(), dateLastEdited: DateTime.now()));
  }


  //TODO: Handle 'add note to a folder'
  void popupMenuController(var value, BuildContext context){
    if (value == commands.deleteNoteVar){
      //Delete note
      dbHandler.removeNote(commands.currentNote);

      setState(() {
        noteList.remove(commands.currentNote);
      });

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

      setState(() {
        if (favoriteList.contains(commands.currentNote)){
          favoriteList.remove(commands.currentNote);
          Fluttertoast.showToast(msg: "Removed note from favorites", toastLength: Toast.LENGTH_LONG);
        }
        else{
          favoriteList.add(commands.currentNote);
          Fluttertoast.showToast(msg: "Added note to favorites", toastLength: Toast.LENGTH_LONG);
        }
      });
    }
  }


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
        itemCount: noteList.length,
        itemBuilder: (context, i){
          return buildItem(noteList[i]);
        },
      );
    }
  }




  Widget buildItem(Note note){

    return Card(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Icon(Icons.insert_drive_file),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${note.noteTitle}",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 12
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${note.noteDescription.substring(0, note.noteDescription.length>20 ? 20 : note.noteDescription.length)}",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${DateFormat('yyyy-MM-dd hh:mm').format(note.dateCreated)}",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 9
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          /*Displays the note language in a rounded box*/
          NoteLanguage(note: note),

          Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: PopupMenuButton(
                itemBuilder: (context){
                  var list =  List<PopupMenuEntry<Object>>();
                  list.add(
                    PopupMenuItem(
                      value: commands.deleteNote(note),
                      child: Text("Delete note"),
                    )
                  );

                  list.add(
                    PopupMenuItem(
                      value: commands.addNoteToFolder(note),
                      child: Text("Add note to a folder"),
                    )
                  );

                  list.add(
                    PopupMenuDivider(
                     height: 2.0
                    )
                  );

                  list.add(
                    PopupMenuItem(
                      //TODO: Check if note is saved in 'favorites'
                      value: commands.noteSaving(note),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: favoriteList.contains(note) ? Text("Unsave") : Text("Save"),
                      ),
                    )
                  );

                  return list;
                },

                onSelected: (value){
                  popupMenuController(value, context);
                },
              )
          )
        ],
      ),
    );
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


class Commands{
  final deleteNoteVar = 1;
  final addNoteToFolderVar = 2;
  final noteSavingVar = 3;
  Note currentNote;

  int deleteNote(Note note){
    currentNote = note;
    return deleteNoteVar;
  }

  int addNoteToFolder(Note note){
    currentNote = note;
    return addNoteToFolderVar;
  }

  int noteSaving(Note note){
    currentNote = note;
    return noteSavingVar;
  }
}