import 'package:flutter/material.dart';

class BookDescription extends StatelessWidget {
  final String bookName;

  const BookDescription({super.key, required this.bookName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(bookName),
      ),
      body: Center(
        child: Text('Description of $bookName'),
      ),
    );
  }
}