// lib/core/models/book_metadata.dart
import 'dart:typed_data';

import 'package:flutter/material.dart';

class BookMetadata {
  final String title;
  final List<String> authors;
  final String filePath;
  final Uint8List? coverImageBytes;

  BookMetadata({
    required this.title,
    required this.authors,
    required this.filePath,
    this.coverImageBytes,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'authors': authors,
    'filePath': filePath,
    'coverImageBytes': coverImageBytes?.toList(),
  };

  factory BookMetadata.fromJson(Map<String, dynamic> json) {
    return BookMetadata(
      title: json['title'] as String,
      authors: List<String>.from(json['authors']),
      filePath: json['filePath'] as String,
      coverImageBytes: json['coverImageBytes'] != null
          ? Uint8List.fromList(List<int>.from(json['coverImageBytes']))
          : null,
    );
  }

  Image? get coverImage => coverImageBytes != null
      ? Image.memory(coverImageBytes!)
      : null;
}