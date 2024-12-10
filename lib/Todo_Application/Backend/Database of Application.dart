import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper _instance =   DatabaseHelper._internal();

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
  static const dynamic taskdateandtime='dateandtime';

  /// Initialize or retrieve the database instance
  static Future<Database> get database async {
    if (_database != null)
      return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize the database
  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'todoapplicationdatabase.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            $taskId INTEGER PRIMARY KEY AUTOINCREMENT,
            $taskName TEXT NOT NULL,
            $taskDescription TEXT  ,
            $taskdateandtime TEXT
          )
        ''');
      },
    );
  }

  /// Create a new item in the database
  static Future<int> insertItem(Map<String, dynamic> item) async {
    final db = await database;
    return await db.insert(
      tableName,
      item,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Retrieve all items from the database
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await database;
    return await db.query(tableName);
  }

  /// Update an item in the database
  static Future<int> updateItem(
      int id,
      String name,
      String description,
      String dateAndTime, // Optional parameter
      ) async {
    final db = await database;

    return await db.update(
      tableName,
      {
        'name': name, // Correct column name
        'description': description,
        'dateandtime': dateAndTime, // Update dateandtime with the provided or current value
      },
      where: 'id = ?', // Correct column for where clause
      whereArgs: [id],
    );
  }

  /// Delete an item from the database
  static Future<int> deleteItem(int id) async {
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
Explanation of the `DatabaseHelper` Class and CRUD Operations:

### Overview
This class provides a structured way to manage SQLite database operations in a Flutter application. It uses the singleton pattern to ensure only one instance of the database is active at any time. The database is initialized with a table named `items` having three columns: `id`, `name`, and `description`.

---

### Key Methods

#### 1. **`insertItem(Map<String, dynamic> item)`**
   - **Purpose**: Adds a new record to the `items` table.
   - **Parameters**:
     - `item`: A map containing the key-value pairs for column names and values to be inserted.
   - **Functionality**:
     - Retrieves the database instance.
     - Inserts the `item` map into the table.
     - Uses `ConflictAlgorithm.replace` to overwrite an existing row with the same ID.
   - **Example**:
     ```dart
     await DatabaseHelper.insertItem({'name': 'Sample Item', 'description': 'A description'});
     ```

#### 2. **`getItems()`**
   - **Purpose**: Fetches all rows from the `items` table.
   - **Parameters**: None.
   - **Functionality**:
     - Retrieves the database instance.
     - Queries the table to get all rows.
   - **Example**:
     ```dart
     List<Map<String, dynamic>> items = await DatabaseHelper.getItems();
     ```

#### 3. **`updateItem(Map<String, dynamic> item)`**
   - **Purpose**: Updates an existing record in the `items` table.
   - **Parameters**:
     - `item`: A map containing the updated values, including the `id` of the item to be updated.
   - **Functionality**:
     - Retrieves the database instance.
     - Updates the row matching the provided ID with the new values in the map.
   - **Example**:
     ```dart
     await DatabaseHelper.updateItem({'id': 1, 'name': 'Updated Item', 'description': 'Updated description'});
     ```

#### 4. **`deleteItem(int id)`**
   - **Purpose**: Deletes a specific record from the `items` table by ID.
   - **Parameters**:
     - `id`: The ID of the item to delete.
   - **Functionality**:
     - Retrieves the database instance.
     - Deletes the row where the `id` matches the provided value.
   - **Example**:
     ```dart
     await DatabaseHelper.deleteItem(1);
     ```

#### 5. **`closeDatabase()`**
   - **Purpose**: Closes the database connection.
   - **Parameters**: None.
   - **Functionality**:
     - Ensures the database is closed to release resources.

---

### Workflow Summary
1. **Initialization**:
   - The database is lazily initialized when accessed for the first time using the `database` getter.
   - The database file is created in the device's app-specific storage, ensuring data persistence.

2. **Table Structure**:
   - The `items` table is created with columns for:
     - `id` (primary key, auto-incremented)
     - `name` (non-null text field)
     - `description` (optional text field)

3. **CRUD Operations**:
   - Each operation (Create, Read, Update, Delete) is encapsulated in a static method for easy reuse.
*/
