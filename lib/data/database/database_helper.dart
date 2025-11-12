import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/health_record_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  static const String _databaseName = 'healthmate.db';
  static const int _databaseVersion = 1;

  static const String tableHealthRecords = 'health_records';
  static const String columnId = 'id';
  static const String columnDate = 'date';
  static const String columnSteps = 'steps';
  static const String columnCalories = 'calories';
  static const String columnWater = 'water';
  static const String columnCreatedAt = 'created_at';
  static const String columnUpdatedAt = 'updated_at';

  DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableHealthRecords (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnDate TEXT NOT NULL,
        $columnSteps INTEGER NOT NULL,
        $columnCalories INTEGER NOT NULL,
        $columnWater INTEGER NOT NULL,
        $columnCreatedAt TEXT NOT NULL,
        $columnUpdatedAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_date ON $tableHealthRecords($columnDate)
    ''');

    await _insertDummyData(db);
  }

  Future<void> _insertDummyData(Database db) async {
    final now = DateTime.now();
    final dummyRecords = [
      {
        columnDate: _formatDate(now),
        columnSteps: 8500,
        columnCalories: 2200,
        columnWater: 2000,
        columnCreatedAt: now.toIso8601String(),
        columnUpdatedAt: now.toIso8601String(),
      },
      {
        columnDate: _formatDate(now.subtract(const Duration(days: 1))),
        columnSteps: 6000,
        columnCalories: 1800,
        columnWater: 1500,
        columnCreatedAt: now.subtract(const Duration(days: 1)).toIso8601String(),
        columnUpdatedAt: now.subtract(const Duration(days: 1)).toIso8601String(),
      },
      {
        columnDate: _formatDate(now.subtract(const Duration(days: 2))),
        columnSteps: 10000,
        columnCalories: 2500,
        columnWater: 2500,
        columnCreatedAt: now.subtract(const Duration(days: 2)).toIso8601String(),
        columnUpdatedAt: now.subtract(const Duration(days: 2)).toIso8601String(),
      },
    ];

    for (var record in dummyRecords) {
      await db.insert(tableHealthRecords, record);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  Future<int> insertRecord(HealthRecord record) async {
    final db = await database;
    return await db.insert(tableHealthRecords, record.toMap());
  }

  Future<List<HealthRecord>> getAllRecords() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableHealthRecords,
      orderBy: '$columnDate DESC',
    );
    return List.generate(maps.length, (i) => HealthRecord.fromMap(maps[i]));
  }

  Future<HealthRecord?> getRecordById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableHealthRecords,
      where: '$columnId = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return HealthRecord.fromMap(maps.first);
  }

  Future<List<HealthRecord>> getRecordsByDate(String date) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableHealthRecords,
      where: '$columnDate = ?',
      whereArgs: [date],
    );
    return List.generate(maps.length, (i) => HealthRecord.fromMap(maps[i]));
  }

  Future<List<HealthRecord>> getTodayRecords() async {
    final today = _formatDate(DateTime.now());
    return await getRecordsByDate(today);
  }

  Future<Map<String, int>> getTodayTotals() async {
    final todayRecords = await getTodayRecords();
    if (todayRecords.isEmpty) {
      return {'steps': 0, 'calories': 0, 'water': 0};
    }
    int totalSteps = 0, totalCalories = 0, totalWater = 0;
    for (var record in todayRecords) {
      totalSteps += record.steps;
      totalCalories += record.calories;
      totalWater += record.water;
    }
    return {'steps': totalSteps, 'calories': totalCalories, 'water': totalWater};
  }

  Future<int> updateRecord(HealthRecord record) async {
    if (record.id == null) throw ArgumentError('Record ID cannot be null');
    final db = await database;
    return await db.update(
      tableHealthRecords,
      record.toUpdateMap(),
      where: '$columnId = ?',
      whereArgs: [record.id],
    );
  }

  Future<int> deleteRecord(int id) async {
    final db = await database;
    return await db.delete(
      tableHealthRecords,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<bool> recordExistsForDate(String date) async {
    final db = await database;
    final result = await db.query(
      tableHealthRecords,
      where: '$columnDate = ?',
      whereArgs: [date],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<int> getTotalSteps(String startDate, String endDate) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT SUM($columnSteps) as total
      FROM $tableHealthRecords
      WHERE $columnDate BETWEEN ? AND ?
    ''', [startDate, endDate]);
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<double> getAverageSteps() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT AVG($columnSteps) as average
      FROM $tableHealthRecords
    ''');
    final value = result.first['average'];
    return (value as num?)?.toDouble() ?? 0.0;
  }
}