import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  // Private constructor
  DatabaseHelper._internal();

  // Factory constructor to return the singleton instance
  factory DatabaseHelper() => _instance;

  // Database instance
  static Database? _database;

  // Table and column names
  static const String tableName = 'todolist';
  static const String taskId = 'id';
  static const String taskName = 'name';
  static const String taskDescription = 'description';
  static const String taskDateAndTime = 'dateandtime';
  static const String taskImagePath = 'imagePath';
  static const String taskVideoPath = 'videoPath';

  /// Retrieve or initialize the database instance
  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize the database
  static Future<Database> _initDatabase() async {
    // Define the path to the database file
    String path = join(await getDatabasesPath(), 'todoapplicationdatabase.db');

    return await openDatabase(
      path,
      version: 2, // Increment the version whenever schema changes
      onCreate: (db, version) async {
        // Create the initial table structure
        await db.execute('''
          CREATE TABLE $tableName (
            $taskId INTEGER PRIMARY KEY AUTOINCREMENT,
            $taskName TEXT NOT NULL,
            $taskDescription TEXT,
            $taskDateAndTime TEXT,
            $taskImagePath TEXT,
            $taskVideoPath TEXT
          )
        '''
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Handle database upgrades if schema changes
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE $tableName ADD COLUMN $taskImagePath TEXT');
          await db.execute('ALTER TABLE $tableName ADD COLUMN $taskVideoPath TEXT');
        }
      },
    );
  }

  /// Insert a new task into the database
  static Future<int> insertTask(Map<String, dynamic> task) async {
    final db = await database;
    return await db.insert(
      tableName,
      task,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Retrieve all tasks from the database
  static Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await database;
    return await db.query(tableName);
  }

  /// Update an existing task in the database
  static Future<dynamic> updateTask(int id, Map<String, dynamic> updatedTask) async {
    final db = await database;
    return await db.update(
      tableName,
      updatedTask,
      where: '$taskId = ?',
      whereArgs: [id],
    );
  }

  /// Delete a task from the database by its ID
  static Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      tableName,
      where: '$taskId = ?',
      whereArgs: [id],
    );
  }

  /// Close the database connection
  static Future<void> closeDatabase() async {
    final db = _database;
    if (db != null) {
      await db.close();
    }
  }
}

/*
### Instructions in Code Comments

1. **Singleton Pattern**:
   - Ensures only one instance of `DatabaseHelper` is active at any time.

2. **Database Initialization**:
   - `_initDatabase()` defines the path to the database file and sets the schema.
   - The `onCreate` callback creates the initial table structure.

3. **Version Management**:
   - `version: 2` specifies the current database version.
   - `onUpgrade` handles schema changes (e.g., adding `imagePath` and `videoPath` columns in version 2).

4. **CRUD Operations**:
   - `insertTask`: Adds a new task to the table. Supports optional fields (`imagePath`, `videoPath`).
   - `getTasks`: Fetches all tasks.
   - `updateTask`: Updates task details by ID.
   - `deleteTask`: Deletes a task by ID.

5. **Schema Flexibility**:
   - Optional fields (`imagePath`, `videoPath`) allow tasks to store images and videos or remain null.

6. **Data Safety**:
   - Incremental schema updates preserve existing user data.
*/
