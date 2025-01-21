import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _initDatabase();
      return _database;
    }
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'event_reminder.db');  // ✅ Database name corrected
    return await openDatabase(path, version: 1, onCreate: _onDatabaseCreate);
  }

  Future<void> _onDatabaseCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        date_time TEXT NOT NULL,
        location TEXT,
        description TEXT,
        category TEXT,
        priority TEXT,
        image_path TEXT NULL,
        file_path TEXT NULL,
        video_path TEXT NULL,
        reminder_time TEXT,  -- Stores the reminder time
        repeat_option TEXT,  -- Stores the repeat option (Daily, Weekly, etc.)
        custom_interval INTEGER NULL -- Stores the custom interval for custom reminders
      )
    ''');
  }

  Future<int> insertEvent(Map<String, dynamic> data) async {
    final db = await database;
    try {
      print("\n \n SQLite Insert Data: $data");
      return await db!.insert('events', data,
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print("SQLite Insert Error: $e");
      return -1; // Return -1 on failure
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllEvents() async {
    final db = await database;
    try {
      return db!.query('events');
    } catch (e) {
      print("SQLite Fetch Error: $e");
      return []; // Return an empty list on failure
    }
  }

  Future<int> updateEvent(Map<String, dynamic> data, int id) async {
    final db = await database;
    return await db!.update('events', data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteEvent(int id) async {
    final db = await database;
    return await db!.delete('events', where: 'id = ?', whereArgs: [id]);
  }
}
