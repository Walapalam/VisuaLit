import 'package:flutter/material.dart';
import 'package:iridium_reader_widget/views/viewers/epub_screen.dart';


class BookReadingScreen extends StatelessWidget {
  final String bookName;

  const BookReadingScreen({super.key, required this.bookName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(bookName),
      ),
      body: Center(
        child: EpubScreen.fromPath(filePath: 'assets/ebooks/01_The_Lightning_Thief.epub')
      ),
    );
  }
}