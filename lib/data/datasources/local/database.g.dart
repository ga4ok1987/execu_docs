// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $RegionsTable extends Regions with TableInfo<$RegionsTable, RegionDto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RegionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'regions';
  @override
  VerificationContext validateIntegrity(
    Insertable<RegionDto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RegionDto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RegionDto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $RegionsTable createAlias(String alias) {
    return $RegionsTable(attachedDatabase, alias);
  }
}

class RegionDto extends DataClass implements Insertable<RegionDto> {
  final int id;
  final String name;
  const RegionDto({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  RegionsCompanion toCompanion(bool nullToAbsent) {
    return RegionsCompanion(id: Value(id), name: Value(name));
  }

  factory RegionDto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RegionDto(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  RegionDto copyWith({int? id, String? name}) =>
      RegionDto(id: id ?? this.id, name: name ?? this.name);
  RegionDto copyWithCompanion(RegionsCompanion data) {
    return RegionDto(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RegionDto(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RegionDto && other.id == this.id && other.name == this.name);
}

class RegionsCompanion extends UpdateCompanion<RegionDto> {
  final Value<int> id;
  final Value<String> name;
  const RegionsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  RegionsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<RegionDto> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  RegionsCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return RegionsCompanion(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RegionsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $ExecutorOfficesTable extends ExecutorOffices
    with TableInfo<$ExecutorOfficesTable, ExecutorOfficeDto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExecutorOfficesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isPrimaryMeta = const VerificationMeta(
    'isPrimary',
  );
  @override
  late final GeneratedColumn<bool> isPrimary = GeneratedColumn<bool>(
    'is_primary',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_primary" IN (0, 1))',
    ),
    defaultValue: Constant(false),
  );
  static const VerificationMeta _regionIdMeta = const VerificationMeta(
    'regionId',
  );
  @override
  late final GeneratedColumn<int> regionId = GeneratedColumn<int>(
    'region_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES regions (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    address,
    isPrimary,
    regionId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'executor_offices';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExecutorOfficeDto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('is_primary')) {
      context.handle(
        _isPrimaryMeta,
        isPrimary.isAcceptableOrUnknown(data['is_primary']!, _isPrimaryMeta),
      );
    }
    if (data.containsKey('region_id')) {
      context.handle(
        _regionIdMeta,
        regionId.isAcceptableOrUnknown(data['region_id']!, _regionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_regionIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExecutorOfficeDto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExecutorOfficeDto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      isPrimary: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_primary'],
      )!,
      regionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}region_id'],
      )!,
    );
  }

  @override
  $ExecutorOfficesTable createAlias(String alias) {
    return $ExecutorOfficesTable(attachedDatabase, alias);
  }
}

class ExecutorOfficeDto extends DataClass
    implements Insertable<ExecutorOfficeDto> {
  final int id;
  final String name;
  final String address;
  final bool isPrimary;
  final int regionId;
  const ExecutorOfficeDto({
    required this.id,
    required this.name,
    required this.address,
    required this.isPrimary,
    required this.regionId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['address'] = Variable<String>(address);
    map['is_primary'] = Variable<bool>(isPrimary);
    map['region_id'] = Variable<int>(regionId);
    return map;
  }

  ExecutorOfficesCompanion toCompanion(bool nullToAbsent) {
    return ExecutorOfficesCompanion(
      id: Value(id),
      name: Value(name),
      address: Value(address),
      isPrimary: Value(isPrimary),
      regionId: Value(regionId),
    );
  }

  factory ExecutorOfficeDto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExecutorOfficeDto(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      address: serializer.fromJson<String>(json['address']),
      isPrimary: serializer.fromJson<bool>(json['isPrimary']),
      regionId: serializer.fromJson<int>(json['regionId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'address': serializer.toJson<String>(address),
      'isPrimary': serializer.toJson<bool>(isPrimary),
      'regionId': serializer.toJson<int>(regionId),
    };
  }

  ExecutorOfficeDto copyWith({
    int? id,
    String? name,
    String? address,
    bool? isPrimary,
    int? regionId,
  }) => ExecutorOfficeDto(
    id: id ?? this.id,
    name: name ?? this.name,
    address: address ?? this.address,
    isPrimary: isPrimary ?? this.isPrimary,
    regionId: regionId ?? this.regionId,
  );
  ExecutorOfficeDto copyWithCompanion(ExecutorOfficesCompanion data) {
    return ExecutorOfficeDto(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      address: data.address.present ? data.address.value : this.address,
      isPrimary: data.isPrimary.present ? data.isPrimary.value : this.isPrimary,
      regionId: data.regionId.present ? data.regionId.value : this.regionId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExecutorOfficeDto(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('isPrimary: $isPrimary, ')
          ..write('regionId: $regionId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, address, isPrimary, regionId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExecutorOfficeDto &&
          other.id == this.id &&
          other.name == this.name &&
          other.address == this.address &&
          other.isPrimary == this.isPrimary &&
          other.regionId == this.regionId);
}

class ExecutorOfficesCompanion extends UpdateCompanion<ExecutorOfficeDto> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> address;
  final Value<bool> isPrimary;
  final Value<int> regionId;
  const ExecutorOfficesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.address = const Value.absent(),
    this.isPrimary = const Value.absent(),
    this.regionId = const Value.absent(),
  });
  ExecutorOfficesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String address,
    this.isPrimary = const Value.absent(),
    required int regionId,
  }) : name = Value(name),
       address = Value(address),
       regionId = Value(regionId);
  static Insertable<ExecutorOfficeDto> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? address,
    Expression<bool>? isPrimary,
    Expression<int>? regionId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (isPrimary != null) 'is_primary': isPrimary,
      if (regionId != null) 'region_id': regionId,
    });
  }

  ExecutorOfficesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? address,
    Value<bool>? isPrimary,
    Value<int>? regionId,
  }) {
    return ExecutorOfficesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      isPrimary: isPrimary ?? this.isPrimary,
      regionId: regionId ?? this.regionId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (isPrimary.present) {
      map['is_primary'] = Variable<bool>(isPrimary.value);
    }
    if (regionId.present) {
      map['region_id'] = Variable<int>(regionId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExecutorOfficesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('isPrimary: $isPrimary, ')
          ..write('regionId: $regionId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RegionsTable regions = $RegionsTable(this);
  late final $ExecutorOfficesTable executorOffices = $ExecutorOfficesTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    regions,
    executorOffices,
  ];
}

typedef $$RegionsTableCreateCompanionBuilder =
    RegionsCompanion Function({Value<int> id, required String name});
typedef $$RegionsTableUpdateCompanionBuilder =
    RegionsCompanion Function({Value<int> id, Value<String> name});

final class $$RegionsTableReferences
    extends BaseReferences<_$AppDatabase, $RegionsTable, RegionDto> {
  $$RegionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ExecutorOfficesTable, List<ExecutorOfficeDto>>
  _executorOfficesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.executorOffices,
    aliasName: $_aliasNameGenerator(db.regions.id, db.executorOffices.regionId),
  );

  $$ExecutorOfficesTableProcessedTableManager get executorOfficesRefs {
    final manager = $$ExecutorOfficesTableTableManager(
      $_db,
      $_db.executorOffices,
    ).filter((f) => f.regionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _executorOfficesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RegionsTableFilterComposer
    extends Composer<_$AppDatabase, $RegionsTable> {
  $$RegionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> executorOfficesRefs(
    Expression<bool> Function($$ExecutorOfficesTableFilterComposer f) f,
  ) {
    final $$ExecutorOfficesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.executorOffices,
      getReferencedColumn: (t) => t.regionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExecutorOfficesTableFilterComposer(
            $db: $db,
            $table: $db.executorOffices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RegionsTableOrderingComposer
    extends Composer<_$AppDatabase, $RegionsTable> {
  $$RegionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RegionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RegionsTable> {
  $$RegionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> executorOfficesRefs<T extends Object>(
    Expression<T> Function($$ExecutorOfficesTableAnnotationComposer a) f,
  ) {
    final $$ExecutorOfficesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.executorOffices,
      getReferencedColumn: (t) => t.regionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExecutorOfficesTableAnnotationComposer(
            $db: $db,
            $table: $db.executorOffices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RegionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RegionsTable,
          RegionDto,
          $$RegionsTableFilterComposer,
          $$RegionsTableOrderingComposer,
          $$RegionsTableAnnotationComposer,
          $$RegionsTableCreateCompanionBuilder,
          $$RegionsTableUpdateCompanionBuilder,
          (RegionDto, $$RegionsTableReferences),
          RegionDto,
          PrefetchHooks Function({bool executorOfficesRefs})
        > {
  $$RegionsTableTableManager(_$AppDatabase db, $RegionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RegionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RegionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RegionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
              }) => RegionsCompanion(id: id, name: name),
          createCompanionCallback:
              ({Value<int> id = const Value.absent(), required String name}) =>
                  RegionsCompanion.insert(id: id, name: name),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RegionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({executorOfficesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (executorOfficesRefs) db.executorOffices,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (executorOfficesRefs)
                    await $_getPrefetchedData<
                      RegionDto,
                      $RegionsTable,
                      ExecutorOfficeDto
                    >(
                      currentTable: table,
                      referencedTable: $$RegionsTableReferences
                          ._executorOfficesRefsTable(db),
                      managerFromTypedResult: (p0) => $$RegionsTableReferences(
                        db,
                        table,
                        p0,
                      ).executorOfficesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.regionId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RegionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RegionsTable,
      RegionDto,
      $$RegionsTableFilterComposer,
      $$RegionsTableOrderingComposer,
      $$RegionsTableAnnotationComposer,
      $$RegionsTableCreateCompanionBuilder,
      $$RegionsTableUpdateCompanionBuilder,
      (RegionDto, $$RegionsTableReferences),
      RegionDto,
      PrefetchHooks Function({bool executorOfficesRefs})
    >;
typedef $$ExecutorOfficesTableCreateCompanionBuilder =
    ExecutorOfficesCompanion Function({
      Value<int> id,
      required String name,
      required String address,
      Value<bool> isPrimary,
      required int regionId,
    });
typedef $$ExecutorOfficesTableUpdateCompanionBuilder =
    ExecutorOfficesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> address,
      Value<bool> isPrimary,
      Value<int> regionId,
    });

final class $$ExecutorOfficesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ExecutorOfficesTable,
          ExecutorOfficeDto
        > {
  $$ExecutorOfficesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RegionsTable _regionIdTable(_$AppDatabase db) =>
      db.regions.createAlias(
        $_aliasNameGenerator(db.executorOffices.regionId, db.regions.id),
      );

  $$RegionsTableProcessedTableManager get regionId {
    final $_column = $_itemColumn<int>('region_id')!;

    final manager = $$RegionsTableTableManager(
      $_db,
      $_db.regions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_regionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExecutorOfficesTableFilterComposer
    extends Composer<_$AppDatabase, $ExecutorOfficesTable> {
  $$ExecutorOfficesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPrimary => $composableBuilder(
    column: $table.isPrimary,
    builder: (column) => ColumnFilters(column),
  );

  $$RegionsTableFilterComposer get regionId {
    final $$RegionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.regionId,
      referencedTable: $db.regions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RegionsTableFilterComposer(
            $db: $db,
            $table: $db.regions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExecutorOfficesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExecutorOfficesTable> {
  $$ExecutorOfficesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPrimary => $composableBuilder(
    column: $table.isPrimary,
    builder: (column) => ColumnOrderings(column),
  );

  $$RegionsTableOrderingComposer get regionId {
    final $$RegionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.regionId,
      referencedTable: $db.regions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RegionsTableOrderingComposer(
            $db: $db,
            $table: $db.regions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExecutorOfficesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExecutorOfficesTable> {
  $$ExecutorOfficesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<bool> get isPrimary =>
      $composableBuilder(column: $table.isPrimary, builder: (column) => column);

  $$RegionsTableAnnotationComposer get regionId {
    final $$RegionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.regionId,
      referencedTable: $db.regions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RegionsTableAnnotationComposer(
            $db: $db,
            $table: $db.regions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExecutorOfficesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExecutorOfficesTable,
          ExecutorOfficeDto,
          $$ExecutorOfficesTableFilterComposer,
          $$ExecutorOfficesTableOrderingComposer,
          $$ExecutorOfficesTableAnnotationComposer,
          $$ExecutorOfficesTableCreateCompanionBuilder,
          $$ExecutorOfficesTableUpdateCompanionBuilder,
          (ExecutorOfficeDto, $$ExecutorOfficesTableReferences),
          ExecutorOfficeDto,
          PrefetchHooks Function({bool regionId})
        > {
  $$ExecutorOfficesTableTableManager(
    _$AppDatabase db,
    $ExecutorOfficesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExecutorOfficesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExecutorOfficesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExecutorOfficesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<bool> isPrimary = const Value.absent(),
                Value<int> regionId = const Value.absent(),
              }) => ExecutorOfficesCompanion(
                id: id,
                name: name,
                address: address,
                isPrimary: isPrimary,
                regionId: regionId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String address,
                Value<bool> isPrimary = const Value.absent(),
                required int regionId,
              }) => ExecutorOfficesCompanion.insert(
                id: id,
                name: name,
                address: address,
                isPrimary: isPrimary,
                regionId: regionId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExecutorOfficesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({regionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (regionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.regionId,
                                referencedTable:
                                    $$ExecutorOfficesTableReferences
                                        ._regionIdTable(db),
                                referencedColumn:
                                    $$ExecutorOfficesTableReferences
                                        ._regionIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ExecutorOfficesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExecutorOfficesTable,
      ExecutorOfficeDto,
      $$ExecutorOfficesTableFilterComposer,
      $$ExecutorOfficesTableOrderingComposer,
      $$ExecutorOfficesTableAnnotationComposer,
      $$ExecutorOfficesTableCreateCompanionBuilder,
      $$ExecutorOfficesTableUpdateCompanionBuilder,
      (ExecutorOfficeDto, $$ExecutorOfficesTableReferences),
      ExecutorOfficeDto,
      PrefetchHooks Function({bool regionId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RegionsTableTableManager get regions =>
      $$RegionsTableTableManager(_db, _db.regions);
  $$ExecutorOfficesTableTableManager get executorOffices =>
      $$ExecutorOfficesTableTableManager(_db, _db.executorOffices);
}
