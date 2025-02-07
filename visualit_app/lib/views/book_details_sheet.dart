import 'package:flutter/material.dart';

class BookDetailsSheet extends StatelessWidget {
  final String bookName;
  final int index;

  const BookDetailsSheet({super.key, required this.bookName, required this.index});

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        bookName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Container(
                        color: Colors.grey[300],
                        height: 185,
                        child: Center(
                          child: Text('Book Image $index'),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Description of the book goes here. This is a placeholder for the book description.',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          // Handle Start/Continue Reading button press
                        },
                        child: const Text('Start Reading'),
                      ),
                      const SizedBox(height: 16.0),
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
                    return ListTile(
                      title: Text('Chapter ${chapterIndex + 1}'),
                      onTap: () {
                        // Handle chapter tap
                      },
                    );
                  },
                  childCount: 10, // Replace with the actual number of chapters
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}