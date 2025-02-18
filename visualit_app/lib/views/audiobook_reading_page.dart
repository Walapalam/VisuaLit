import 'package:flutter/material.dart';
import '../core/models/book.dart';
import 'package:flutter_html/flutter_html.dart';
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
    // Ensure the chapter index is within valid range
    if (currentChapterIndex < 0 || currentChapterIndex >= book.chapters.length) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Chapter Not Found"),
          backgroundColor: Colors.white,
          elevation: 2,
        ),
        body: const Center(
          child: Text(
            "Oops! The chapter couldn't be found.",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    final chapter = book.chapters[currentChapterIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          chapter.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black26,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Html(
                data: chapter.htmlContent, // Directly render HTML content
                style: {
                  "body": Style(
                    fontSize: FontSize(18),
                    lineHeight: LineHeight.number(1.8),
                    textAlign: TextAlign.justify,
                    padding: HtmlPaddings.zero,
                    margin: Margins.zero,
                  ),
                },
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
