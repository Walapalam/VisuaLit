import 'package:flutter/material.dart';
import '../core/models/book.dart';
import 'book_listening_screen.dart';

class ListeningWidget extends StatelessWidget {
  final Book? currentBook;
  final VoidCallback onClose;

  const ListeningWidget({
    super.key,
    required this.currentBook,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    if (currentBook == null) return SizedBox.shrink();

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.primaryDelta! > 10) {
            onClose(); // Close when dragged down
          } else if (details.primaryDelta! < -10) {
            _openFullScreen(context); // Expand when dragged up
          }
        },
        onTap: () {
          _openFullScreen(context); // Expand when tapped
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
          ),
          height: 70, // Fixed height
          child: Row(
            children: [
              currentBook?.coverImage ??
                  Icon(Icons.book, color: Colors.white, size: 40),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  currentBook?.title ?? "Unknown Book",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: Icon(Icons.pause, color: Colors.white),
                onPressed: onClose,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openFullScreen(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Makes it full-screen height
      backgroundColor: Colors.transparent, // Optional for smooth look
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 1, // Starts fully expanded
        minChildSize: 1, // Prevents resizing
        builder: (_, controller) => BookListeningScreen(
          book: currentBook!,
          onClose: onClose,
        ),
      ),
    );
  }
}
