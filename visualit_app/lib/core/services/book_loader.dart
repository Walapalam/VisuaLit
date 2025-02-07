// lib/core/services/book_loader.dart
import 'dart:ui';
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

      // Extract metadata and content
      String title = epubBook.Title ?? 'Unknown Title';
      String author = epubBook.Author ?? 'Unknown Author';
      List<String> authors = epubBook.AuthorList?.whereType<String>().toList() ?? [];
      Image? coverImage;
      coverImage = null; //Cant seem to get this to work >_<

      List<Chapter> chapters = epubBook.Chapters?.map((epubx.EpubChapter chapter) {
        return Chapter(
          title: chapter.Title ?? '',
          htmlContent: chapter.HtmlContent ?? '',
          subChapters: chapter.SubChapters?.map((subChapter) {
            return Chapter(
              title: subChapter.Title ?? '',
              htmlContent: subChapter.HtmlContent ?? '',
              subChapters: [],
            );
          }).toList() ?? [],
        );
      }).toList() ?? [];

      Map<String, epubx.EpubByteContentFile> images = epubBook.Content?.Images ?? {};
      Map<String, epubx.EpubTextContentFile> htmlFiles = epubBook.Content?.Html ?? {};
      Map<String, epubx.EpubTextContentFile> cssFiles = epubBook.Content?.Css ?? {};
      Map<String, epubx.EpubByteContentFile> fonts = epubBook.Content?.Fonts ?? {};
      Map<String, epubx.EpubContentFile> allFiles = epubBook.Content?.AllFiles ?? {};

      List<Contributor> contributors = epubBook.Schema?.Package?.Metadata?.Contributors?.map((contributor) {
        return Contributor(
          name: contributor.Contributor ?? '',
          role: contributor.Role ?? '',
        );
      }).toList() ?? [];

      List<Metadata> metadata = epubBook.Schema?.Navigation?.Head?.Metadata?.map((meta) {
        return Metadata(
          name: meta.Name ?? '',
          content: meta.Content ?? '',
        );
      }).toList() ?? [];

      books.add(Book(
        title: title,
        author: author,
        authors: authors,
        coverImage: null,
        chapters: chapters,
        images: images,
        htmlFiles: htmlFiles,
        cssFiles: cssFiles,
        fonts: fonts,
        allFiles: allFiles,
        contributors: contributors,
        metadata: metadata,
      ));
    } catch (e) {
      print('Error parsing EPUB file: $e');
    }
  }
  return books;
}