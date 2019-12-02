

const String homeRoute = '/';

const String databaseName = "note_database.db";
const String databaseNotesTableName = "notes";
const String databaseFoldersTableName = "folders";
const String databaseNotesTableProperties = "id INTEGER PRIMARY KEY, title TEXT, description TEXT, content TEXT, created TEXT, last_edited TEXT, folder_id INTEGER, FOREIGN KEY(folder_id) REFERENCES folders (id), saved INTEGER";
const String databaseFoldersTableProperties = "id INTEGER PRIMARY KEY, title TEXT, description TEXT";