class Note{
  final int noteId;
  String noteTitle;
  String noteDescription;
  String noteContent;
  final DateTime dateCreated;
  DateTime dateLastEdited;

  Note({this.noteId, this.noteTitle, this.noteDescription, this.noteContent, this.dateCreated, this.dateLastEdited});

  Map<String, dynamic> toMap(){
    return {
      "id" : noteId,
      "title" : noteTitle,
      "description" : noteDescription,
      "content" : noteContent,
      "created" : dateCreated.toIso8601String(),
      "last_edited" : dateLastEdited.toIso8601String(),
      "is_saved" : 0
    };
  }
}