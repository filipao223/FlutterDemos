

const String homeRoute = '/';
const String addNoteRoute = '/addNote';
const String addFolderRoute = '/addFolder';

const String databaseName = "note_database.db";
const String databaseNotesTableName = "notes";
const String databaseFoldersTableName = "folders";
const String databaseNotesTableProperties = "id INTEGER PRIMARY KEY, title TEXT, description TEXT, content TEXT, created TEXT, last_edited TEXT, folder_id INTEGER, is_saved INTEGER, language TEXT, FOREIGN KEY(folder_id) REFERENCES folders (id)";
const String databaseFoldersTableProperties = "id INTEGER PRIMARY KEY, title TEXT, description TEXT";

const int isFolder = 1;
const int isNote = 2;

const List<String> languages = [
  "Dart" ,
  "C" ,
  "C++" ,
  "Java" ,
  "Python" ,
];