// lib/core/services/book_loader.dart
import 'package:flutter/material.dart';
import 'package:epubx/epubx.dart' as epubx;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import '../models/book.dart';

Future<List<Book>> loadBooks() async {
  List<Book> books = [];
  final manifestContent = await rootBundle.loadString('AssetManifest.json');
  final Map<String, dynamic> manifestMap = json.decode(manifestContent);
  final bookPaths = manifestMap.keys
      .where((String key) => key.contains('assets/ebooks/'))
      .toList();

  for (String path in bookPaths) {
    try {
      // Read the file as bytes
      List<int> bytes = await rootBundle.load(path).then((data) => data.buffer.asUint8List());

      // Open the book and read all of its content into memory
      epubx.EpubBook epubBook = await epubx.EpubReader.readBook(bytes);

      // Create a Book instance using the epubBook
      books.add(Book(epubBook, path));
    } catch (e) {
      print('Error parsing EPUB file: $e');
    }
  }
  return books;
}