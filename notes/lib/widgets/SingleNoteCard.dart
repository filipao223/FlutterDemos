

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/controllers/Controllers.dart';
import 'package:notes/models/Commands.dart';
import 'package:notes/models/Folder.dart';
import 'package:notes/models/Note.dart';

import 'NoteLanguage.dart';

class SingleNoteCardState extends State<SingleNoteCard>{

  Note note;
  List<Note> noteList, favoriteList;
  List<Folder> folderList;
  Commands commands = Commands();

  SingleNoteCardState({this.note, this.noteList, this.folderList, this.favoriteList});


  @override
  void initState() {
    widget.streamController.stream.listen((_){
      triggerRebuild();
    });
    super.initState();
  }


  void triggerRebuild(){
    setState(() {

    });
  }


  @override
  void dispose() {
    widget.streamController.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Card(
      key: Key(note.noteId.toString()),

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
                      "${DateFormat('yyyy-MM-dd HH:mm').format(note.dateCreated)}",
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
                  Controllers().popupMenuController(value, context, noteList, this, widget.streamController);
                },
              )
          )
        ],
      ),
    );
  }
}


class SingleNoteCard extends StatefulWidget{

  Note note;
  List<Note> noteList, favoriteList;
  List<Folder> folderList;

  final StreamController<void> streamController = StreamController<void>();

  SingleNoteCard({this.note, this.noteList, this.folderList, this.favoriteList});

  SingleNoteCardState createState() =>
      SingleNoteCardState(
        note: note,
        noteList: noteList,
        folderList: folderList,
        favoriteList: favoriteList,
      );
}