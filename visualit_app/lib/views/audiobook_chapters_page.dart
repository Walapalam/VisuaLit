import 'package:flutter/material.dart';
import '../core/models/book.dart';

class ChaptersPage extends StatelessWidget {
  final Book book;
  final ValueChanged<int> onChapterSelected;

  const ChaptersPage({super.key, required this.book, required this.onChapterSelected});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: book.chapters.length,
      itemBuilder: (context, index) {
        final chapter = book.chapters[index];
        return ListTile(
          title: Text(chapter.title),
          onTap: () => onChapterSelected(index),
        );
      },
    );
  }
}