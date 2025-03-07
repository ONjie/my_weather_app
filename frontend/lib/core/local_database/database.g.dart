// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $FavoriteLocationsTable extends FavoriteLocations
    with TableInfo<$FavoriteLocationsTable, FavoriteLocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoriteLocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _locationNameMeta =
      const VerificationMeta('locationName');
  @override
  late final GeneratedColumn<String> locationName = GeneratedColumn<String>(
      'location_name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _countryMeta =
      const VerificationMeta('country');
  @override
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
      'country', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, locationName, country, latitude, longitude];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorite_locations';
  @override
  VerificationContext validateIntegrity(Insertable<FavoriteLocation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('location_name')) {
      context.handle(
          _locationNameMeta,
          locationName.isAcceptableOrUnknown(
              data['location_name']!, _locationNameMeta));
    } else if (isInserting) {
      context.missing(_locationNameMeta);
    }
    if (data.containsKey('country')) {
      context.handle(_countryMeta,
          country.isAcceptableOrUnknown(data['country']!, _countryMeta));
    } else if (isInserting) {
      context.missing(_countryMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FavoriteLocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FavoriteLocation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      locationName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location_name'])!,
      country: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}country'])!,
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude'])!,
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude'])!,
    );
  }

  @override
  $FavoriteLocationsTable createAlias(String alias) {
    return $FavoriteLocationsTable(attachedDatabase, alias);
  }
}

class FavoriteLocation extends DataClass
    implements Insertable<FavoriteLocation> {
  final int id;
  final String locationName;
  final String country;
  final double latitude;
  final double longitude;
  const FavoriteLocation(
      {required this.id,
      required this.locationName,
      required this.country,
      required this.latitude,
      required this.longitude});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['location_name'] = Variable<String>(locationName);
    map['country'] = Variable<String>(country);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    return map;
  }

  FavoriteLocationsCompanion toCompanion(bool nullToAbsent) {
    return FavoriteLocationsCompanion(
      id: Value(id),
      locationName: Value(locationName),
      country: Value(country),
      latitude: Value(latitude),
      longitude: Value(longitude),
    );
  }

  factory FavoriteLocation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FavoriteLocation(
      id: serializer.fromJson<int>(json['id']),
      locationName: serializer.fromJson<String>(json['locationName']),
      country: serializer.fromJson<String>(json['country']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'locationName': serializer.toJson<String>(locationName),
      'country': serializer.toJson<String>(country),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
    };
  }

  FavoriteLocation copyWith(
          {int? id,
          String? locationName,
          String? country,
          double? latitude,
          double? longitude}) =>
      FavoriteLocation(
        id: id ?? this.id,
        locationName: locationName ?? this.locationName,
        country: country ?? this.country,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
      );
  FavoriteLocation copyWithCompanion(FavoriteLocationsCompanion data) {
    return FavoriteLocation(
      id: data.id.present ? data.id.value : this.id,
      locationName: data.locationName.present
          ? data.locationName.value
          : this.locationName,
      country: data.country.present ? data.country.value : this.country,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteLocation(')
          ..write('id: $id, ')
          ..write('locationName: $locationName, ')
          ..write('country: $country, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, locationName, country, latitude, longitude);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FavoriteLocation &&
          other.id == this.id &&
          other.locationName == this.locationName &&
          other.country == this.country &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude);
}

class FavoriteLocationsCompanion extends UpdateCompanion<FavoriteLocation> {
  final Value<int> id;
  final Value<String> locationName;
  final Value<String> country;
  final Value<double> latitude;
  final Value<double> longitude;
  const FavoriteLocationsCompanion({
    this.id = const Value.absent(),
    this.locationName = const Value.absent(),
    this.country = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
  });
  FavoriteLocationsCompanion.insert({
    this.id = const Value.absent(),
    required String locationName,
    required String country,
    required double latitude,
    required double longitude,
  })  : locationName = Value(locationName),
        country = Value(country),
        latitude = Value(latitude),
        longitude = Value(longitude);
  static Insertable<FavoriteLocation> custom({
    Expression<int>? id,
    Expression<String>? locationName,
    Expression<String>? country,
    Expression<double>? latitude,
    Expression<double>? longitude,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (locationName != null) 'location_name': locationName,
      if (country != null) 'country': country,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    });
  }

  FavoriteLocationsCompanion copyWith(
      {Value<int>? id,
      Value<String>? locationName,
      Value<String>? country,
      Value<double>? latitude,
      Value<double>? longitude}) {
    return FavoriteLocationsCompanion(
      id: id ?? this.id,
      locationName: locationName ?? this.locationName,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (locationName.present) {
      map['location_name'] = Variable<String>(locationName.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteLocationsCompanion(')
          ..write('id: $id, ')
          ..write('locationName: $locationName, ')
          ..write('country: $country, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FavoriteLocationsTable favoriteLocations =
      $FavoriteLocationsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [favoriteLocations];
}

typedef $$FavoriteLocationsTableCreateCompanionBuilder
    = FavoriteLocationsCompanion Function({
  Value<int> id,
  required String locationName,
  required String country,
  required double latitude,
  required double longitude,
});
typedef $$FavoriteLocationsTableUpdateCompanionBuilder
    = FavoriteLocationsCompanion Function({
  Value<int> id,
  Value<String> locationName,
  Value<String> country,
  Value<double> latitude,
  Value<double> longitude,
});

class $$FavoriteLocationsTableFilterComposer
    extends Composer<_$AppDatabase, $FavoriteLocationsTable> {
  $$FavoriteLocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get locationName => $composableBuilder(
      column: $table.locationName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get country => $composableBuilder(
      column: $table.country, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));
}

class $$FavoriteLocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $FavoriteLocationsTable> {
  $$FavoriteLocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get locationName => $composableBuilder(
      column: $table.locationName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get country => $composableBuilder(
      column: $table.country, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));
}

class $$FavoriteLocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FavoriteLocationsTable> {
  $$FavoriteLocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get locationName => $composableBuilder(
      column: $table.locationName, builder: (column) => column);

  GeneratedColumn<String> get country =>
      $composableBuilder(column: $table.country, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);
}

class $$FavoriteLocationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FavoriteLocationsTable,
    FavoriteLocation,
    $$FavoriteLocationsTableFilterComposer,
    $$FavoriteLocationsTableOrderingComposer,
    $$FavoriteLocationsTableAnnotationComposer,
    $$FavoriteLocationsTableCreateCompanionBuilder,
    $$FavoriteLocationsTableUpdateCompanionBuilder,
    (
      FavoriteLocation,
      BaseReferences<_$AppDatabase, $FavoriteLocationsTable, FavoriteLocation>
    ),
    FavoriteLocation,
    PrefetchHooks Function()> {
  $$FavoriteLocationsTableTableManager(
      _$AppDatabase db, $FavoriteLocationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FavoriteLocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavoriteLocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavoriteLocationsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> locationName = const Value.absent(),
            Value<String> country = const Value.absent(),
            Value<double> latitude = const Value.absent(),
            Value<double> longitude = const Value.absent(),
          }) =>
              FavoriteLocationsCompanion(
            id: id,
            locationName: locationName,
            country: country,
            latitude: latitude,
            longitude: longitude,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String locationName,
            required String country,
            required double latitude,
            required double longitude,
          }) =>
              FavoriteLocationsCompanion.insert(
            id: id,
            locationName: locationName,
            country: country,
            latitude: latitude,
            longitude: longitude,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FavoriteLocationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FavoriteLocationsTable,
    FavoriteLocation,
    $$FavoriteLocationsTableFilterComposer,
    $$FavoriteLocationsTableOrderingComposer,
    $$FavoriteLocationsTableAnnotationComposer,
    $$FavoriteLocationsTableCreateCompanionBuilder,
    $$FavoriteLocationsTableUpdateCompanionBuilder,
    (
      FavoriteLocation,
      BaseReferences<_$AppDatabase, $FavoriteLocationsTable, FavoriteLocation>
    ),
    FavoriteLocation,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FavoriteLocationsTableTableManager get favoriteLocations =>
      $$FavoriteLocationsTableTableManager(_db, _db.favoriteLocations);
}
