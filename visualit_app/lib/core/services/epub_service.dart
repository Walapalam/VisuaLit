// lib/core/services/epub_service.dart
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:epubx/epubx.dart' as epubx;
import 'package:visualit_app/core/models/book.dart';
import 'package:flutter/material.dart';

class EpubService {
  Future<Book> createBookFromEpub(String filePath) async {
    var targetFile = io.File(filePath);
    List<int> bytes = await targetFile.readAsBytes();
    epubx.EpubBook epubBook = await epubx.EpubReader.readBook(bytes);

    return Book(epubBook);
  }
}