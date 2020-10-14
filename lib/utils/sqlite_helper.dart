import 'package:sqflite/sqflite.dart';
import 'package:notes/models/note.dart';
import 'package:notes/models/label.dart';

class SqlLiteHelper {
  final sqlFileName = 'note.db';
  final dailyTable = 'take_note';
  Database db;

  Future<void> open() async {
    String path = "${await getDatabasesPath()}/$sqlFileName";
    print(path);
    if (db == null) {
      db = await openDatabase(path, version: 1, onCreate: (db, ver) async {
        await db.execute('''
        Create Table take_note(
          id integer primary key autoincrement,
          title text,
          noteBody text,
          createdDate int,
          updatedDate int,
          background text,
        );
        ''');
        await db.execute('''
        Create Table note_label(
          id integer primary key autoincrement,
          label text,
          updatedDate int,
        );
        ''');
      });
    }
  }

  // Note Operations
  // insert
  Future<void> insert(Note note) async {
    await db.insert(
      dailyTable,
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // queryAll
  Future<List<Note>> queryAll() async {
    final List<Map<String, dynamic>> maps =
        await db.query(dailyTable, orderBy: "updatedDate DESC");
    return List.generate(maps.length, (i) {
      return Note(
        id: maps[i]['id'],
        title: maps[i]['title'],
        noteBody: maps[i]['noteBody'],
        createdDate: maps[i]['createdDate'],
        updatedDate: maps[i]['updatedDate'],
        background: maps[i]['background'],
      );
    });
  }

  // update
  Future<void> update(Note note) async {
    await db.update(
      dailyTable,
      note.toMap(),
      where: "id = ?",
      whereArgs: [note.id],
    );
  }

  // delete
  Future<void> delete(Note note) async {
    await db.delete(
      dailyTable,
      where: "id = ?",
      whereArgs: [note.id],
    );
  }

  // Label Operations

  // insert
  Future<void> insertLabel(Label label, String table) async {
    await db.insert(
      table,
      label.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // queryAll
  Future<List<Label>> queryAllLabel(String table) async {
    final List<Map<String, dynamic>> maps =
        await db.query(dailyTable, orderBy: "updatedDate DESC");
    return List.generate(maps.length, (i) {
      return Label(
        id: maps[i]['id'],
        label: maps[i]['label'],
        updatedDate: maps[i]['updatedDate'],
      );
    });
  }

  // update
  Future<void> updateLabel(Label label) async {
    await db.update(
      dailyTable,
      label.toMap(),
      where: "id = ?",
      whereArgs: [label.id],
    );
  }

  // delete
  Future<void> deleteLabel(Label label) async {
    await db.delete(
      dailyTable,
      where: "id = ?",
      whereArgs: [label.id],
    );
  }
}
