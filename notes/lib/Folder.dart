import 'Note.dart';

class Folder{
  final int folderId;
  String folderTitle;
  String folderDescription;
  List<Note> noteList = List<Note>();

  /*Expansionlist info*/
  bool isExpanded = false;

  void createPlaceholderNotes(){
    noteList = new List<Note>();

    noteList.add(new Note(noteId: 1, noteTitle: "title1", noteContent: "test", dateCreated: DateTime.now(), dateLastEdited: DateTime.now()));
    noteList.add(new Note(noteId: 2, noteTitle: "title2", noteContent: "test", dateCreated: DateTime.now(), dateLastEdited: DateTime.now()));
    noteList.add(new Note(noteId: 3, noteTitle: "title3", noteContent: "test", dateCreated: DateTime.now(), dateLastEdited: DateTime.now()));
    noteList.add(new Note(noteId: 4, noteTitle: "title1", noteContent: "test", dateCreated: DateTime.now(), dateLastEdited: DateTime.now()));
    noteList.add(new Note(noteId: 5, noteTitle: "title2", noteContent: "test", dateCreated: DateTime.now(), dateLastEdited: DateTime.now()));
    noteList.add(new Note(noteId: 6, noteTitle: "title3", noteContent: "test", dateCreated: DateTime.now(), dateLastEdited: DateTime.now()));
  }

  Folder({this.folderId, this.folderDescription, this.folderTitle});

  Map<String, dynamic> toMap(){
    return {
      "id" : folderId,
      "title" : folderTitle,
      "description" : folderDescription
    };
  }
}