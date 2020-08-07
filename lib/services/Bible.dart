import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

class Verse {
  final Bible bible;

  final int bookNumber;
  final int chapter;
  final int verse;
  final String text;

  static Verse fromResult(Bible bible, Map<String, dynamic> result) {
      return Verse(
        bible: bible,
        bookNumber: result['book_number'],
        chapter: result['chapter'],
        verse: result['verse'],
        text: result['text'],
      );
  }

  Verse({ this.bible, this.bookNumber, this.chapter, this.verse, this.text });

}

class Book {
  final Bible bible;

  final int bookNumber;
  final String shortName;
  final String name;
  int _chapters;

  static Book fromResult(Bible bible, Map<String, dynamic> result) {
      return Book(
        bible: bible,
        bookNumber: result['book_number'],
        shortName: result['short_name'],
        name: result['long_name'],
      );
  }

  static Future<Book> fromVerse(Verse verse) {
    return findByBookNumber(verse.bible, verse.bookNumber);
  }

  static Future<Book> findByBookNumber(Bible bible, int bookNumber) async {
    final Database db = await bible.open();

    final List<Map<String, dynamic>> data = await db.query('books',
        where: 'book_number = ?',
        whereArgs: [bookNumber],
    );

    if (data.length == 0) {
      return Future.error('Unable to find book by number $bookNumber');
    }

    return fromResult(bible, data.first);
  }

  static Future<Book> findByBookName(Bible bible, String bookName) async {
    print('Book.findByBookName, $bible $bookName');
    final Database db = await bible.open();

    final List<Map<String, dynamic>> data = await db.query('books',
        where: 'LOWER(long_name) LIKE ? OR LOWER(short_name) = ?',
        whereArgs: [
          '%${bookName.toLowerCase()}%',
          '%${bookName.toLowerCase()}%',
        ],
    );

    if (data.length == 0) {
      return Future.error('Unable to find book by name $bookName');
    }

    return fromResult(bible, data.first);
  }

  Book({ this.bible, this.bookNumber, this.shortName, this.name });

  Future<int> chapters() async {
    if (_chapters != null) {
      return Future.value(_chapters);
    }

    var db = await bible.open();

    final List<Map<String, dynamic>> chapterData = await db.query('verses',
        distinct: true,
        where: 'book_number = ?',
        whereArgs: [bookNumber],
        columns: [
          'book_number',
          'MAX(chapter) as chapters'
        ],
        groupBy: 'book_number',
    );

    if (chapterData.length > 0) {
      _chapters = chapterData.first['chapters'];
      return chapters();
    }

    return Future.value(0);
  }

  Future<List<Verse>> verses(int chapter) async {
    var db = await bible.open();

    final List<Map<String, dynamic>> data = await db.query('verses',
        distinct: true,
        where: 'book_number = ? AND chapter = ?',
        whereArgs: [bookNumber, chapter],
        orderBy: 'verse ASC',
    );

    return List.generate(
      data.length,
      (index) => Verse.fromResult(bible, data[index]),
    );
  }
}

class Bible {
  Future<Database> database;

  Future<Database> open() async {
    if (database != null) {
      return database;
    }

    var databasesPath = await getDatabasesPath();
    var databaseAppPath = join(databasesPath, 'nasbible_app.sqlite3');
    await deleteDatabase(databaseAppPath);
    try {
      await Directory(dirname(databaseAppPath)).create(recursive: true);
    } catch (_) {}
    ByteData data = await rootBundle.load(join('assets', 'nasb_plus.sqlite3'));
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await new File(databaseAppPath).writeAsBytes(bytes, flush: true);
    database = openDatabase(databaseAppPath, readOnly: true);
    return database;
  }

  Future<void> close() async {
    if (database == null) {
      return Future.value();
    }
    var db = await open();
    return db.close();
  }

  Future<List<Verse>> searchVerses(String terms) async {
    final Database db = await open();

    List<String> words = terms
        .replaceAll(new RegExp(r'[^A-Za-z0-9: ]'), '')
        .split(' ')
        .where((word) => word.length > 3);

    String whereString = words
        .map((word) => "text LIKE ?")
        .join(' AND ');

    final List<Map<String, dynamic>> data = await db.query('verses',
        where: whereString,
        whereArgs: words.map((word) => "%$word%").toList(),
    );

    return List.generate(
      data.length,
      (index) => Verse(
          bookNumber: data[index]['book_number'],
          chapter: data[index]['chapter'],
          verse: data[index]['verse'],
          text: data[index]['text'],
      ),
    );
  }

  Future<List<Book>> books() async {
    final Database db = await open();

    final List<Map<String, dynamic>> data = await db.query('books',
        orderBy: 'book_number ASC',
    );

    return List.generate(
      data.length,
      (index) {
        return Book.fromResult(this, data[index]);
      },
    );
  }
}
