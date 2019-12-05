

import 'package:notes/constants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:notes/Note.dart';
import 'package:notes/Folder.dart';

class DBHandler{
  Future<Database> database;
  int currentNoteId, currentFolderId;

  init() async{
    /*Create database path (for iOS and Android)*/
    final path = join(await getDatabasesPath(), databaseName);

    /*Open the database (creating it, if it doesn't yet exist)*/
    database = openDatabase(
      path,
      onCreate: (database, version){
        var batchDb = database.batch();
        batchDb.execute("CREATE TABLE $databaseFoldersTableName ($databaseFoldersTableProperties)");
        batchDb.execute("CREATE TABLE $databaseNotesTableName ($databaseNotesTableProperties)");
        return batchDb.commit();
      },
      version: 1,
    );
  }


  Future<void> checkCurrentId(int type) async{
    final Database db = await database;

    var data = await db.rawQuery("SELECT * FROM ${type == isNote ? databaseNotesTableName : databaseFoldersTableName} ORDER BY id DESC LIMIT 1");
    if (data != null && data.length > 0){
      if (type == isNote) currentNoteId = data[0]["id"] + 1;
      else currentFolderId = data[0]["id"] + 1;
    }
    else{
      if (type == isNote) currentNoteId = 0;
      else currentFolderId = 0;
    }

    print("CURRENT ${type == isNote ? "NOTE" : "FOLDER"} ID: ${type == isNote ? currentNoteId : currentFolderId}");
  }


  Future<int> addNote(Note note) async{
    final Database db = await database;

    //Get max id
    await checkCurrentId(isNote);

    return db.insert(databaseNotesTableName, note.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }



  Future<int> addNoteToFolder(Folder folder, Note note) async{
    //TODO: Implement addNoteToFolder
    final Database db = await database;

    return db.rawUpdate("UPDATE $databaseNotesTableName SET folder_id = ${folder.folderId} WHERE id = ${note.noteId}");
  }

  Future<int> removeNoteFromFolder(Note note) async{
    //TODO: Implement removeNoteFromFolder
    final Database db = await database;

    return db.rawUpdate("UPDATE $databaseNotesTableName SET folder_id = null WHERE id = ${note.noteId}");
  }

  Future<int> addFolder(Folder folder) async{
    final Database db = await database;

    //Get max id
    await checkCurrentId(isFolder);

    return db.insert(databaseFoldersTableName, folder.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> removeFolder(Folder folder) async{
    final Database db = await database;

    return db.delete(databaseNotesTableName, where: "id = ?", whereArgs: [folder.folderId]);
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
          dateLastEdited: DateTime.parse(maps[i]['last_edited']),
          isSaved: maps[i]['is_saved']==1 ? true : false
      );
    });
  }

  Future<List<Folder>> retrieveFolders() async{
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query(databaseFoldersTableName);

    return List.generate(maps.length, (i) {
      return Folder(
        folderId: maps[i]['id'],
        folderTitle: maps[i]['title'],
        folderDescription: maps[i]['description']
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


  Future<int> changeNoteFavoriteStatus(Note note) async{
    final Database db = await database;

    return db.update(databaseNotesTableName, note.toMap(), where: "id = ?", whereArgs: [note.noteId]);
  }

}