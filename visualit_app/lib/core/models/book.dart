// lib/models/book.dart
import 'package:epubx/epubx.dart';

class Book {
  final String title;
  final String author;
  final List<String> authors;
  final Image? coverImage;
  final List<Chapter> chapters;
  final Map<String, EpubByteContentFile> images;
  final Map<String, EpubTextContentFile> htmlFiles;
  final Map<String, EpubTextContentFile> cssFiles;
  final Map<String, EpubByteContentFile> fonts;
  final Map<String, EpubContentFile> allFiles;
  final List<Contributor> contributors;
  final List<Metadata> metadata;

  Book({
    required this.title,
    required this.author,
    required this.authors,
    this.coverImage,
    required this.chapters,
    required this.images,
    required this.htmlFiles,
    required this.cssFiles,
    required this.fonts,
    required this.allFiles,
    required this.contributors,
    required this.metadata,
  });
}

class Chapter {
  final String title;
  final String htmlContent;
  final List<Chapter> subChapters;

  Chapter({
    required this.title,
    required this.htmlContent,
    required this.subChapters,
  });
}

class Contributor {
  final String name;
  final String role;

  Contributor({
    required this.name,
    required this.role,
  });
}

class Metadata {
  final String name;
  final String content;

  Metadata({
    required this.name,
    required this.content,
  });
}