

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notes/DBHandler.dart';

import 'Note.dart';
import 'constants.dart';

class AddNoteState extends State<AddNote>{

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  DBHandler dbHandler;


  void initDBHandler(){
    this.dbHandler = DBHandler();
  }


  void onSavePressed() async{

    await dbHandler.init();
    await dbHandler.checkCurrentId(isNote);

    Note note = Note(noteId: dbHandler.currentNoteId,
        noteTitle: titleController.text,
        noteDescription: descriptionController.text,
        noteContent: contentController.text,
        dateCreated: DateTime.now(),
        dateLastEdited: DateTime.now()
    );

    await dbHandler.addNote(note);

    Fluttertoast.showToast(msg: "Added new note", toastLength: Toast.LENGTH_LONG);
    Navigator.pop(context, note);
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Add new note"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add), onPressed: onSavePressed,)
        ],
      ),

      body: buildBody(),
    );
  }

  Widget buildBody(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[

        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Title: "),

              Flexible(
                child: TextField(
                  controller: titleController,
                ),
              )
            ],
          ),
        ),

        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Description: "),

              Flexible(
                child: TextField(
                  controller: descriptionController,
                ),
              )
            ],
          ),
        ),

        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Content: "),

              Flexible(
                child: TextField(
                  controller: contentController,
                ),
              )
            ],
          ),
        ),

      ],
    );
  }
}


class AddNote extends StatefulWidget{

  AddNoteState createState(){
    AddNoteState addNoteState = AddNoteState();
    addNoteState.initDBHandler();
    return addNoteState;
  }
}