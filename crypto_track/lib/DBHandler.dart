

import 'package:crypto_track/CryptoList.dart';
import 'package:crypto_track/constants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
          "CREATE TABLE $databaseCoinTableName ($databaseCoinTableProperties)",
        );
      },
      version: 1,
    );
  }

  Future<int> addCoin(Coin coin) async{
    final Database db = await database;
    
    return db.insert(databaseCoinTableName, coin.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Coin>> retrieveCoins() async{
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query(databaseCoinTableName);

    return List.generate(maps.length, (i) {
      return Coin(
        name: maps[i]['name'],
        id: maps[i]['id'],
        price: maps[i]['price'],
        volumeMonth: maps[i]['volume_month']
      );
    });
  }

}