class Note{
  final int noteId;
  String noteTitle;
  String noteDescription;
  String noteContent;
  final DateTime dateCreated;
  DateTime dateLastEdited;
  bool isSaved = false;
  String noteLanguage;

  Note({this.noteId, this.noteTitle, this.noteDescription, this.noteContent, this.dateCreated, this.dateLastEdited, this.isSaved, this.noteLanguage});

  Map<String, dynamic> toMap(){
    return {
      "id" : noteId,
      "title" : noteTitle,
      "description" : noteDescription,
      "content" : noteContent,
      "created" : dateCreated.toIso8601String(),
      "last_edited" : dateLastEdited.toIso8601String(),
      "is_saved" : isSaved ? 1 : 0,
      "language" : noteLanguage
    };
  }
}