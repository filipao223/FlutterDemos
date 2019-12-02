

import 'package:notes/constants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:notes/Note.dart';
import 'package:notes/Folder.dart';

class DBHandler{
  Future<Database> database;

  init() async{
    /*Create database path (for iOS and Android)*/
    final path = join(await getDatabasesPath(), databaseName);

    /*Open the database (creating it, if it doesn't yet exist)*/
    database = openDatabase(
      path,
      onCreate: (database, version){
        return database.execute(
          "CREATE TABLE $databaseNotesTableName ($databaseNotesTableProperties)",
        );
      },
      version: 1,
    );
  }

  Future<int> addNote(Note note) async{
    final Database db = await database;

    return db.insert(databaseNotesTableName, note.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }



  Future<int> addNoteToFolder(Note note) async{
    //TODO: Implement addNoteToFolder
    return 0;
  }

  Future<int> removeNoteFromFolder(Note note) async{
    //TODO: Implement removeNoteFromFolder
    return 0;
  }

  Future<int> addFolder(Folder folder) async{
    //TODO: Implement addFolder
    return 0;
  }

  Future<int> removeFolder(Folder folder) async{
    //TODO: Implement removeFolder
    return 0;
  }




  Future<List<Note>> retrieveNotes() async{
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query(databaseNotesTableName);

    return List.generate(maps.length, (i) {
      return Note(
          noteId: maps[i]['id'],
          noteTitle: maps[i]['title'],
          noteDescription: maps[i]['description'],
          noteContent: maps[i]['content'],
          dateCreated: DateTime.parse(maps[i]['created']),
          dateLastEdited: DateTime.parse(maps[i]['last_edited'])
      );
    });
  }


  Future<int> removeNote(Note note) async{
    final Database db = await database;

    if (note == null){
      print("Error, note is null");
      return -1;
    }

    if (db == null){
      print("Error, database object is null");
      return -2;
    }

    return db.delete(databaseNotesTableName, where: "id = ?", whereArgs: [note.noteId]);
  }

}