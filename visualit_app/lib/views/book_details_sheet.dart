import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../core/models/book.dart';
import 'book_listening_screen.dart';
import 'reading_screen.dart';

class BookDetailsSheet extends StatelessWidget {
  final Book book;

  const BookDetailsSheet({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.8,
      maxChildSize: 1.0,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: CustomScrollView(
            controller: scrollController,
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (book.coverImage != null)
                        SizedBox(
                          width: 100,
                          height: 150,
                          child: book.coverImage,
                        ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              book.title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Author(s): ${book.authors.join(', ')}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 16.0),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookReadingScreen(book: book),
                                  ),
                                );
                              },
                              icon: const Icon(CupertinoIcons.book),
                              label: const Text('Start Reading'),
                            ),
                            const SizedBox(height: 8.0),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookListeningScreen(book: book, onClose: () => Navigator.pop(context)),
                                  ),
                                );
                              },
                              icon: const Icon(CupertinoIcons.headphones),
                              label: const Text('Start Listening'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Chapters',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, chapterIndex) {
                    final chapter = book.chapters[chapterIndex];
                    return ListTile(
                      title: Text(chapter.title),
                      onTap: () {
                        // Handle chapter tap
                      },
                    );
                  },
                  childCount: book.chapters.length,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Images',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: book.images.values.map((image) {
                          return Container(
                            width: 100,
                            height: 100,
                            child: image,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}