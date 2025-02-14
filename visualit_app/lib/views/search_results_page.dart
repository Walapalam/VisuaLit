// lib/views/search_results_page.dart
import 'package:flutter/material.dart';
import '../core/models/book.dart';
import 'book_details_sheet.dart';

class SearchResultsPage extends StatelessWidget {
  final List<Book> filteredBooks;

  const SearchResultsPage({super.key, required this.filteredBooks});

  void _showBookDetails(BuildContext context, Book book) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return BookDetailsSheet(book: book);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: filteredBooks.length,
          itemBuilder: (context, index) {
            final book = filteredBooks[index];
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
                      child: book.coverImage ?? const Center(child: Text('No Cover')),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}