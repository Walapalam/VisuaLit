// lib/views/home.dart
import 'package:flutter/material.dart';
import '../core/services/book_loader.dart';
import '../core/models/book.dart';
import 'book_details_sheet.dart';
import 'reading_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _showMostViewed = true;
  bool _isViewAllMode = false;
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

  Future<void> _loadBooks() async {
    List<String> books = ["",""];
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

  void _showBookDetails(BuildContext context, String bookName, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return BookDetailsSheet(bookName: bookName, index: index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> booksToShow = ["",""];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (!_isViewAllMode) ...[
            // Search bar with tweaking icon
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
            // Horizontal scrollable row
            SizedBox(
              height: 120, // Further adjusted height to make it smaller
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: booksToShow.map((book) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookReadingScreen(bookName: "Book"),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Container(
                            color: Colors.grey[300],
                            width: 100, // Further adjusted width to match the smaller height
                            height: 120, // Further adjusted height to match the smaller size
                            child: Center(child: Text('No Cover')),
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
          // Titles
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
          // Books grid
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
                itemCount: 5,
                itemBuilder: (context, index) {
                  final book = 0;
                  return GestureDetector(
                    onTap: () {
                      _showBookDetails(context, "", index);
                    },
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3.0),
                          child: Container(
                            color: Colors.grey[300],
                            width: 145,
                            height: 185,
                            child:  Center(child: Text('No Cover')),
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          "",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis, // This will add ellipsis (...) at the end if the text overflows
                          maxLines: 1, // This will limit the text to one line
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
    );
  }
}