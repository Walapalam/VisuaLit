import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../core/models/book.dart';
import '../core/models/book_metadata.dart';
import '../core/services/epub_service.dart';
import 'reading_screen.dart';

class BookDetailsSheet extends StatefulWidget {
  final BookMetadata bookMetadata;

  const BookDetailsSheet({super.key, required this.bookMetadata});

  @override
  State<BookDetailsSheet> createState() => _BookDetailsSheetState();
}

class _BookDetailsSheetState extends State<BookDetailsSheet> {
  late Future<Book> _bookFuture;
  final EpubService _epubService = EpubService();

  @override
  void initState() {
    super.initState();
    _bookFuture = _epubService.loadBook(widget.bookMetadata.filePath);
  }

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
          child: FutureBuilder<Book>(
            future: _bookFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData) {
                return const Center(child: Text('No data available'));
              }

              final book = snapshot.data!;

              return CustomScrollView(
                controller: scrollController,
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          if (widget.bookMetadata.coverImage != null)
                            SizedBox(
                              width: 100,
                              height: 150,
                              child: widget.bookMetadata.coverImage,
                            ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  widget.bookMetadata.title,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  'Author(s): ${widget.bookMetadata.authors.join(', ')}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 16.0),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BookReadingScreen(
                                          bookMetadata: widget.bookMetadata,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(CupertinoIcons.book),
                                  label: const Text('Start Reading'),
                                ),
                                const SizedBox(height: 8.0),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // Handle start listening action
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookReadingScreen(
                                  bookMetadata: widget.bookMetadata,
                                ),
                              ),
                            );
                          },
                        );
                      },
                      childCount: book.chapters.length,
                    ),
                  ),
                  if (book.images.isNotEmpty)
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
                                return SizedBox(
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
              );
            },
          ),
        );
      },
    );
  }
}