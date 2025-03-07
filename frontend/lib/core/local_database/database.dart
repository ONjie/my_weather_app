import 'dart:io';
import 'package:drift/native.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'database.g.dart';

class FavoriteLocations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get locationName => text().withLength(min: 1, max: 50)();
  TextColumn get country => text().withLength(min: 1, max: 50)();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
}

@DriftDatabase(tables: [FavoriteLocations])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;
 
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    final cachebase = (await getTemporaryDirectory()).path;

    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}
