import 'Note.dart';

class Folder{
  final int folderId;
  String folderTitle;
  String folderDescription;
  List<Note> noteList = List<Note>();

  /*Expansionlist info*/
  bool isExpanded = false;

  Folder({this.folderId, this.folderDescription, this.folderTitle});

  Map<String, dynamic> toMap(){
    return {
      "id" : folderId,
      "title" : folderTitle,
      "description" : folderDescription
    };
  }
}