import 'dart:io';

import 'package:flutter/material.dart';
import 'package:visualit_app/core/services/epub_service.dart';
import '../core/services/book_loader.dart';
import '../core/models/book.dart';
import 'book_details_sheet.dart';
import 'reading_screen.dart';
import '../core/models/book_metadata.dart';
import '../core/services/book_cache.dart';
import 'package:file_picker/file_picker.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<BookMetadata> _books = [];
  List<BookMetadata> _mostViewedBooks = [];
  List<BookMetadata> _recentlyUploadedBooks = [];
  bool _showMostViewed = true;
  bool _isViewAllMode = false;
  final ScrollController _scrollController = ScrollController();
  final BookCache _bookCache = BookCache();
  final EpubService _epubService = EpubService();

  @override
  void initState() {
    super.initState();
    _loadBooks();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _pickAndImportBook() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['epub'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        String fileName = result.files.single.name;

        // Copy file to assets/ebooks
        final String ebooksPath = 'assets/ebooks/';
        await Directory(ebooksPath).create(recursive: true);
        await file.copy('$ebooksPath/$fileName');

        // Update book cache
        await _bookCache.cacheBooks();
        await _loadBooks();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Book imported successfully')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error importing book: $e')),
        );
      }
    }
  }

  Future<void> refreshBooks() async {
    await _loadBooks();
  }

  Future<void> _loadBooks() async {
    List<BookMetadata> books = await _bookCache.loadCachedBooks();

    if (books.isEmpty) {
      await _bookCache.cacheBooks();
      books = await _bookCache.loadCachedBooks();
    }

    setState(() {
      _books = books;
      _mostViewedBooks = books;
      _recentlyUploadedBooks = books;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels > 50) {
      setState(() {
        _isViewAllMode = true;
      });
    } else {
      setState(() {
        _isViewAllMode = false;
      });
    }
  }

  void _showBookDetails(BuildContext context, BookMetadata book) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return BookDetailsSheet(bookMetadata: book);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<BookMetadata> booksToShow = _showMostViewed ? _mostViewedBooks : _recentlyUploadedBooks;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top:16.0, left: 16.0, right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (!_isViewAllMode) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Stack(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: IconButton(
                          icon: const Icon(Icons.tune),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showMostViewed = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                        ),
                        child: const Text('Most Viewed'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showMostViewed = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                        ),
                        child: const Text('Recently Uploaded'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
                    height: 120,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: booksToShow.map((book) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookReadingScreen(bookMetadata: book),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Container(
                                  color: Colors.transparent,
                                  width: 80,
                                  height: 120,
                                  child: book.coverImage ?? const Center(child: Text('No Cover')),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16.0),
              ],
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Your Books',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: _isViewAllMode ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _isViewAllMode = true;
                          });
                        },
                        child: const Text(
                          'View All',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GridView.builder(
                    controller: _scrollController,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _books.length,
                    itemBuilder: (context, index) {
                      final book = _books[index];
                      return GestureDetector(
                        onTap: () {
                          _showBookDetails(context, book);
                        },
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(3.0),
                              child: Container(
                                color: Colors.grey[300],
                                width: 130,
                                height: 185,
                                child: book.coverImage ?? const Center(child: Text('No Cover')),
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              book.title,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 16.0,
          bottom: 16.0,
          child: FloatingActionButton(
            onPressed: _pickAndImportBook,
            backgroundColor: Colors.black,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }
}