import 'dart:async';

import 'package:flutter/cupertino.dart';
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
    final path = join(dbPath, 'event_reminder.db'); // Database file path
    final db = await openDatabase(
      path,
      version: 3,
      // Make sure the version number is incremented when you upgrade
      onCreate: _onDatabaseCreate,
      onUpgrade: _onUpgradeDatabase,
      onConfigure: _onConfigure,
    ); // Enabling foreign key constraints
    return db;
  }

  //This is the code for configuration purpose
  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
    debugPrint("✅ Foreign key constraints enabled.");
  }

  // Create tables when the database is created
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
        reminder_time TEXT, 
        repeat_option TEXT, 
        custom_interval INTEGER NULL
      )
    ''');

    await db.execute('''
    CREATE TABLE event_files (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      eventfile_id INTEGER NOT NULL,
      path TEXT NOT NULL,
      extension TEXT NOT NULL,
      FOREIGN KEY (eventfile_id) REFERENCES events(id) ON DELETE CASCADE
    )
  ''');
    debugPrint("✅ events table created.");
    debugPrint("✅ event_files table created.");
  }

  // Insert event data into the events table
  Future<int> insertEvent(Map<String, dynamic> data) async {
    final db = await database;
    try {
      debugPrint("\n \n SQLite Insert Data: $data");
      return await db!
          .insert('events', data, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      debugPrint("SQLite Insert Error: $e");
      return -1; // Return -1 on failure
    }
  }

  // Fetch all events from the events table
  Future<List<Map<String, dynamic>>> fetchAllEvents() async {
    final db = await database;
    try {
      return db!.query('events');
    } catch (e) {
      debugPrint("SQLite Fetch Error: $e");
      return []; // Return an empty list on failure
    }
  }

  // Update an event in the events table
  Future<int> updateEvent(Map<String, dynamic> data, int id) async {
    final db = await database;
    return await db!.update('events', data, where: 'id = ?', whereArgs: [id]);
  }

  // Delete an event from the events table
  Future<int> deleteEvent(int id) async {
    final db = await database;
    return await db!.delete('events', where: 'id = ?', whereArgs: [id]);
  }

  // Handle database schema upgrade
  Future<void> _onUpgradeDatabase(
      Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS event_files(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          eventfile_id INTEGER NOT NULL,
          path TEXT NOT NULL,
          extension TEXT NOT NULL,
          FOREIGN KEY (eventfile_id) REFERENCES events(id) ON DELETE CASCADE
        )
      ''');
      debugPrint(
          "✅ Database upgraded to version $newVersion: event_files table added.");
    }
  }

  // Insert file data into the event_files table
  Future<void> insertEventFiles(
      int eventId, List<Map<String, String>> files) async {
    files.length > 0
        ? print("✅ Files to be inserted: $files")
        :print("❌ No files to insert.");
    print("\n"+eventId.toString()+"\n");
    print("\n Insert function work here properly ");
    final db = await database;
    for (var file in files) {
      final path = file['path'];
      final extension = file['extension'];
      db!.insert('event_files', {
        'eventfile_id': eventId,
        'path': path,
        'extension': extension,
      });
      debugPrint("\n ✅ File inserted: $path, extension: $extension \n");
    }
    debugPrint("✅ Files inserted into event_files table.");
  }

  // Fetch event files based on the eventId
  Future<List<Map<String, dynamic>>> fetchEventFiles(int eventId) async {
    print("\n"+ "EVENT-ID NUMBER"+eventId.toString()+"\n");
    final db = await database;
    try {
      dynamic store=await db!
          .query('event_files', where: 'eventfile_id = ?', whereArgs: [eventId]);

      print("\n"+store.toString()+"\n");
      return store;
    } catch (e) {
      debugPrint("SQLite Fetch Error: $e");
      return []; // Return an empty list if fetching fails
    }
  }
    //This is for the Deleting the file with the event ID
    Future<void>deleteEventFiles(int Id)async{
      final db=await database;
      try{
       await db?.delete('event_files',where :'id = ?',whereArgs: [Id]).
      then((value){
        print("\n Deleted event files with event ID: $Id \n");
       });

      }catch(e){
        debugPrint("SQLite Delete Error: $e");
      }
    }
  Future<void> printAllFiles() async {
    final db = await database;
    final files = await db!.query('event_files');
    for (var file in files) {
      print("📄 File: $file");
    }
  }

}
