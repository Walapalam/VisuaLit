// lib/core/models/book.dart
import 'dart:typed_data';
import 'package:epubx/epubx.dart' as epubx;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class Book {
  final epubx.EpubBook epubBook;

  var filepath;

  //Book(epubx.EpubBook? epubBook) : epubBook = epubBook ?? epubx.EpubBook();

  Book(this.epubBook, this.filepath);

  String get title => epubBook.Title ?? "";
  String get author => epubBook.Author ?? "";
  List<String> get authors => epubBook.AuthorList?.whereType<String>().toList() ?? [];
  Image? get coverImage => epubBook.CoverImage != null ? Image.memory(Uint8List.fromList(img.encodePng(epubBook.CoverImage!))) : null;
  List<Chapter> get chapters => epubBook.Chapters?.map((chapter) => Chapter(chapter)).toList() ?? [];
  Map<String, Image> get images {
    final images = <String, Image>{};
    epubBook.Content?.Images?.forEach((key, value) {
      images[key] = Image.memory(Uint8List.fromList(value.Content!));
    });
    return images;
  }
}

class Chapter {
  final epubx.EpubChapter epubChapter;

  Chapter(this.epubChapter);

  String get title => epubChapter.Title ?? "";
  String get htmlContent => epubChapter.HtmlContent ?? "";
  List<Chapter> get subChapters => epubChapter.SubChapters?.map((subChapter) => Chapter(subChapter)).toList() ?? [];
}