import 'package:flutter/material.dart';

class BookReadingScreen extends StatelessWidget {
  final String bookName;

  const BookReadingScreen({super.key, required this.bookName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(bookName),
      ),
      body: Center(
        child: Text('Reading $bookName'),
      ),
    );
  }
}