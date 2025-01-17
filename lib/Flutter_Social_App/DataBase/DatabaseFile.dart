import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Database helper class to manage SQLite operations
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Getter to access the database, initializes if null
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('event_manager.db');
    return _database!;
  }

  // Initialize the database file
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Create the events table with all required fields
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,  // Unique ID for each event
        name TEXT NOT NULL,                   // Name of the event
        date_time TEXT NOT NULL,              // Date and time of the event
        location TEXT,                        // Location of the event
        description TEXT,                     // Description of the event
        category TEXT,                        // Category of the event (e.g., Work, Personal)
        priority TEXT,                        // Priority level (High, Medium, Low)
        image_path TEXT,                      // Path to the selected image (optional)
        video_path TEXT,                      // Path to the selected video (optional)
        file_path TEXT                        // Path to the selected file (optional)
      )
    ''');
  }

  // Insert a new event into the database
  Future<int> insertEvent(Map<String, dynamic> event) async {
    final db = await instance.database;
    return await db.insert('events', event);  // Insert the event and return the generated ID
  }

  // Fetch all events from the database
  Future<List<Map<String, dynamic>>> fetchEvents() async {
    final db = await instance.database;
    return await db.query('events');  // Retrieve all rows from the events table
  }

  // Close the database connection
  Future<void> close() async {
    final db = await instance.database;
    db.close();  // Close the database to free resources
  }
}
