


const String homeRoute = '/';
const String searchRoute = '/search';
const String detailsRoute = '/details';


const String databaseName = 'coin_database.db';
const String databaseCoinTableName = 'coins';
const String databaseCoinTableProperties = 'rowid INTEGER PRIMARY KEY, id TEXT, name TEXT, price REAL, volume_month REAL, url_picture TEXT';


const int DELETED_COIN = 1;
const int OK = 0;
const int ERROR = -1;