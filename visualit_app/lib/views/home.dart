import 'package:flutter/material.dart';
import 'package:visualit_app/core/services/epub_service.dart';
import '../core/services/book_loader.dart';
import '../core/models/book.dart';
import 'book_details_sheet.dart';
import 'reading_screen.dart';
import 'audiobook_widget.dart';
import '../core/models/book_metadata.dart';
import '../core/services/book_cache.dart';

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
  bool _showListeningWidget = false; // Controls the draggable widget visibility
  Book? _currentListeningBook; // Tracks the current playing book
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

  void _toggleListeningWidget(Book book) {
    setState(() {
      _showListeningWidget = true;
      _currentListeningBook = book;
    });
  }

  void _hideListeningWidget() {
    setState(() {
      _showListeningWidget = false;
      _currentListeningBook = null;
    });
  }

  Future<void> _loadBooks() async {
    // Load cached metadata
    List<BookMetadata> books = await _bookCache.loadCachedBooks();

    if (books.isEmpty) {
      // If cache is empty, create it
      await _bookCache.cacheBooks();
      books = await _bookCache.loadCachedBooks();
    }

    setState(() {
      _books = books;
      _mostViewedBooks = books; // Replace with logic to get most viewed books
      _recentlyUploadedBooks = books; // Replace with logic for recent books
    });
  }

  void _onScroll() {
    setState(() {
      _isViewAllMode = _scrollController.position.pixels > 50;
    });
  }

  void _showBookDetails(BuildContext context, BookMetadata book) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return BookDetailsSheet(
            bookMetadata: book,
            onStartListening: () {
              _toggleListeningWidget(book);
              Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<BookMetadata> booksToShow = _showMostViewed ? _mostViewedBooks : _recentlyUploadedBooks;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
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
                          prefixIcon: Icon(Icons.search),
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
                          icon: Icon(Icons.tune),
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
                SizedBox(
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
                                builder: (context) => BookReadingScreen(book: book),
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
                                child: book.coverImage ?? Center(child: Text('No Cover')),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
              ],
              Row(
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
                                width: 145,
                                height: 185,
                                child: book.coverImage ?? Center(child: Text('No Cover')),
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              book.title,
                              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
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

        // Draggable Listening Widget
    // Listening Widget - Rectangular and Draggable
    if (_showListeningWidget && _currentListeningBook != null)
    ListeningWidget(
    currentBook: _currentListeningBook,
    onClose: _hideListeningWidget,
    ),
      ],
    );
  }
}