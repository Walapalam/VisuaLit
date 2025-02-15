import 'package:flutter/material.dart';
import '../core/models/book.dart';
import 'package:html/parser.dart' as htmlParser;
import 'listening_screen_nav_bar_page.dart';

class AudioBookReadingPage extends StatelessWidget {
  final Book book;
  final int currentChapterIndex;
  final Widget navBar;

  const AudioBookReadingPage({
    super.key,
    required this.book,
    required this.currentChapterIndex,
    required this.navBar,
  });

  @override
  Widget build(BuildContext context) {
    final chapter = book.chapters[currentChapterIndex];
    final document = htmlParser.parse(chapter.htmlContent);
    final plainText = document.body?.text ?? '';

    return Scaffold(
      backgroundColor: Colors.white, // White background for a clean look
      appBar: AppBar(
        title: Text(
          chapter.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black, // Black text for contrast
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black26,
        iconTheme: const IconThemeData(color: Colors.black), // Black icons
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Text(
                plainText,
                style: const TextStyle(
                  fontSize: 18,
                  height: 1.8,
                  fontWeight: FontWeight.w400,
                  color: Colors.black, // Black text for readability
                  letterSpacing: 0.4, // Slight spacing for better reading
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Colors.black12),
          navBar,
        ],
      ),
    );
  }
}
