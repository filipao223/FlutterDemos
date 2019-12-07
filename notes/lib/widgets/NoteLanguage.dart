

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:notes/models/Note.dart';

class NoteLanguageState extends State<NoteLanguage>{

  final Note note;

  NoteLanguageState({this.note});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return //TODO: Maybe change the layout of the language text
      Container(
        width: 70,
        child: Padding(
          padding: EdgeInsets.all(7.0),
          child: Align(
            alignment: Alignment.center,
            child: AutoSizeText(
              "${note.noteLanguage.contains("none") ? "Txt" : note.noteLanguage}",
              maxLines: 1,
              minFontSize: 10.0,
            ),
          ),
        ),

        decoration: BoxDecoration(
          color: Colors.black12,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.elliptical(60, 50)),
        ),
      );
  }
}

class NoteLanguage extends StatefulWidget{

  final Note note;

  NoteLanguage({this.note});

  NoteLanguageState createState() => NoteLanguageState(note: note);
}