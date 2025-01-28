import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:weather_app/Data/Models/favorite_locations_model.dart';

class FavoriteLocationsDatabase {

  static final FavoriteLocationsDatabase instance = FavoriteLocationsDatabase._init();

  static Database? _database;

  FavoriteLocationsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('favorite_locations.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const doubleType = 'DOUBLE NOT NULL';

    await db.execute('''CREATE TABLE $tableName ( 
  ${FavoriteLocationFields.id} $idType, 
  ${FavoriteLocationFields.locationName} $textType,
  ${FavoriteLocationFields.latitude} $doubleType,
  ${FavoriteLocationFields.longitude} $doubleType
  )
''');
  }

 Future<void> addFavoriteLocation(FavoriteLocation location) async{
    final db = await instance.database;

    await db.insert(tableName, location.toJson());
 }

 Future<List<FavoriteLocation>> getAllFavoriteLocations() async{
    final db = await instance.database;

    const orderBy = '${FavoriteLocationFields.id} ASC';

    final result = await db.query(tableName, orderBy: orderBy);

    return result.map((json) => FavoriteLocation.fromJson(json)).toList();
 }

 Future<void> deleteFavoriteLocation(int id) async{
    final db = await instance.database;

    await db.delete(tableName, where: '${FavoriteLocationFields.id} = ?', whereArgs: [id]);
 }

 Future close() async{
    final db = await instance.database;

    db.close();
 }

}
