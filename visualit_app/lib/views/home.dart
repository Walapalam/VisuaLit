// lib/views/home.dart
import 'package:flutter/material.dart';
import '../core/services/book_loader.dart';
import '../core/models/book.dart';
import 'book_details_sheet.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Book> _books = [];

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    List<Book> books = await loadBooks();
    setState(() {
      _books = books;
    });
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
                    // Handle Most Viewed button press
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                  ),
                  child: const Text('Most Viewed'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle Recently Uploaded button press
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
                TextButton(
                  onPressed: () {
                    // Handle View All button press
                  },
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      color: Colors.grey,
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
                      _showBookDetails(context, book.title, index);
                    },
                    child: Column(
                      children: [
                        Container(
                          color: Colors.grey[300],
                          width: 145,
                          height: 185,
                          child: book.coverImage != null
                              ? Image.memory(book.coverImage!.getBytes())
                              : Center(child: Text('No Cover')),
                        ),
                        const SizedBox(height: 8.0),
                        Flexible(
                          child: Text(
                            book.title,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
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