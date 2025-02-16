// lib/views/home.dart
import 'package:flutter/material.dart';
import '../core/services/book_loader.dart';
import '../core/models/book.dart';
import 'book_details_sheet.dart';
import 'reading_screen.dart';
import 'book_listening_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Book> _books = [];
  List<Book> _mostViewedBooks = [];
  List<Book> _recentlyUploadedBooks = [];
  bool _showMostViewed = true;
  bool _isViewAllMode = false;
  bool _showListeningWidget = false; // New state for listening widget
  Book? _currentListeningBook; // Track the currently playing book
  final ScrollController _scrollController = ScrollController();


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
    List<Book> books = await loadBooks();
    setState(() {
      _books = books;
      _mostViewedBooks = books; // Replace with actual logic to get most viewed books
      _recentlyUploadedBooks = books; // Replace with actual logic to get recently uploaded books
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

  void _showBookDetails(BuildContext context, Book book) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return BookDetailsSheet(
          book: book,
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
    List<Book> booksToShow = _showMostViewed ? _mostViewedBooks : _recentlyUploadedBooks;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (!_isViewAllMode) ...[
                // Search Bar
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
                          onPressed: () {
                            // Handle tweaking icon press
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),

                // Buttons
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

                // Horizontal Scrollable Row
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

              // Title
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

              // Books Grid
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
                              style: TextStyle(
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

        // Listening Widget
        if (_showListeningWidget && _currentListeningBook != null)
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookListeningScreen(
                      book: _currentListeningBook!,
                      onClose: _hideListeningWidget,
                    ),
                  ),
                );
              },
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: _currentListeningBook!.coverImage ?? Icon(Icons.book, color: Colors.white),
                    ),
                    Expanded(
                      child: Text(
                        _currentListeningBook!.title,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.pause, color: Colors.white),
                      onPressed: _hideListeningWidget,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}