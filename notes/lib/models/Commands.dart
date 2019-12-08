

/*Represents the different options in the popup menus of the note cards*/
/*Singleton class*/

import 'Note.dart';

class Commands{

  static final Commands instance = Commands._internal();

  final deleteNoteVar = 1;
  final addNoteToFolderVar = 2;
  final noteSavingVar = 3;
  Note currentNote;


  factory Commands(){
    return instance;
  }


  Commands._internal();


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