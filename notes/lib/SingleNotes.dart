

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes/AddToFolderDialog.dart';
import 'package:notes/DBHandler.dart';
import 'package:notes/Note.dart';

import 'Folder.dart';
import 'constants.dart';

class SingleNotesState extends State<SingleNotes>{

  List<Note> noteList;
  List<Folder> folderList;
  DBHandler dbHandler = DBHandler();

  SingleNotesState(List<Note> listNotes, List<Folder> listFolders){this.noteList = listNotes; this.folderList = listFolders;}


  void createPlaceholderNotes(){
    noteList = new List<Note>();

    noteList.add(new Note(noteId: 1, noteTitle: "title1", noteContent: "test", dateCreated: DateTime.now(), dateLastEdited: DateTime.now()));
    noteList.add(new Note(noteId: 2, noteTitle: "title2", noteContent: "test", dateCreated: DateTime.now(), dateLastEdited: DateTime.now()));
    noteList.add(new Note(noteId: 3, noteTitle: "title3", noteContent: "test", dateCreated: DateTime.now(), dateLastEdited: DateTime.now()));
  }


  //TODO: Handle 'add note to a folder'
  void popupMenuController(var value, BuildContext context){
    if (value is Note){
      //Delete note
      dbHandler.removeNote(value);

      setState(() {
        noteList.remove(value);
      });

      Fluttertoast.showToast(msg: "Deleted note", toastLength: Toast.LENGTH_LONG);
    }

    else{
      //Add note to a folder
      showDialog(
        context: context,
        builder: (context){
          return AddToFolderDialog(folderList, value[0]);
        }
      );
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

    return ListView.builder(
      itemCount: noteList.length,
      itemBuilder: (context, i){
        return buildItem(noteList[i]);
      },
    );
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
                      "${note.noteContent.substring(0, note.noteContent.length>20 ? 20 : note.noteContent.length)}",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${note.dateCreated.toIso8601String()}",
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

          Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: note,
                    child: Text("Delete note"),
                  ),

                  PopupMenuItem(
                    value: [note, 1],
                    child: Text("Add note to a folder"),
                  )
                ],

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

  List<Note> noteList;
  List<Folder> folderList;

  SingleNotes(List<Note> listNotes, List<Folder> listFolders){this.noteList = listNotes; this.folderList = listFolders;}

  SingleNotesState createState(){
    SingleNotesState singleNotesState = SingleNotesState(noteList, folderList);
    /*Do something*/
    //singleNotesState.createPlaceholderNotes();
    return singleNotesState;
  }
}