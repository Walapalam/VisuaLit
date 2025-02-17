// lib/core/services/book_cache.dart
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:epubx/epubx.dart' as epubx;
import '../models/book_metadata.dart';
import 'package:image/image.dart' as img;

class BookCache {
  static const String cacheFileName = 'book_cache.json';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$cacheFileName');
  }

  Future<List<BookMetadata>> loadCachedBooks() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) {
        return [];
      }

      final contents = await file.readAsString();
      final List<dynamic> jsonList = json.decode(contents);
      return jsonList.map((json) => BookMetadata.fromJson(json)).toList();
    } catch (e) {
      print('Error loading cached books: $e');
      return [];
    }
  }

  Future<void> cacheBooks() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    final bookPaths = manifestMap.keys
        .where((String key) => key.contains('assets/ebooks/'))
        .toList();

    List<BookMetadata> metadata = [];

    for (String path in bookPaths) {
      try {
        List<int> bytes = await rootBundle.load(path)
            .then((data) => data.buffer.asUint8List());

        // Only read the metadata
        epubx.EpubBook epubBook = await epubx.EpubReader.readBook(bytes);

        Uint8List? coverImageBytes;
        if (epubBook.CoverImage != null) {
          coverImageBytes = Uint8List.fromList(
              img.encodePng(epubBook.CoverImage!));
        }

        metadata.add(BookMetadata(
          title: epubBook.Title ?? "",
          authors: epubBook.AuthorList?.whereType<String>().toList() ?? [],
          filePath: path,
          coverImageBytes: coverImageBytes,
        ));
      } catch (e) {
        print('Error caching book $path: $e');
      }
    }

    final file = await _localFile;
    await file.writeAsString(json.encode(
      metadata.map((m) => m.toJson()).toList(),
    ));
  }

  Future<void> clearCache() async {
    final file = await _localFile;
    if (await file.exists()) {
      await file.delete();
    }
  }
}