// lib/core/services/epub_service.dart
import 'package:flutter/services.dart';
import '../models/book.dart';
import 'package:epubx/epubx.dart';

class EpubService {
  Future<Book> loadBook(String filePath) async {
    List<int> bytes = await rootBundle.load(filePath)
        .then((data) => data.buffer.asUint8List());
    EpubBook epubBook = await EpubReader.readBook(bytes);
    return Book(epubBook, filePath);
  }
}