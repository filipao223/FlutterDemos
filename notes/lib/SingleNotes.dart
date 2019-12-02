

import 'package:flutter/material.dart';
import 'package:notes/Note.dart';

class SingleNotesState extends State<SingleNotes>{

  List<Note> noteList;

  SingleNotesState(List<Note> list){this.noteList = List<Note>(); noteList.addAll(list);}


  void createPlaceholderNotes(){
    noteList = new List<Note>();

    noteList.add(new Note(noteId: 1, noteTitle: "title1", noteContent: "test", dateCreated: DateTime.now(), dateLastEdited: DateTime.now()));
    noteList.add(new Note(noteId: 2, noteTitle: "title2", noteContent: "test", dateCreated: DateTime.now(), dateLastEdited: DateTime.now()));
    noteList.add(new Note(noteId: 3, noteTitle: "title3", noteContent: "test", dateCreated: DateTime.now(), dateLastEdited: DateTime.now()));
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
              child: Icon(Icons.menu)
          )
        ],
      ),
    );
  }
}


class SingleNotes extends StatefulWidget{

  List<Note> noteList;

  SingleNotes(List<Note> list){this.noteList = list;}

  SingleNotesState createState(){
    SingleNotesState singleNotesState = SingleNotesState(noteList);
    /*Do something*/
    //singleNotesState.createPlaceholderNotes();
    return singleNotesState;
  }
}