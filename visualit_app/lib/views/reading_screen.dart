import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../core/models/book.dart';

class BookReadingScreen extends StatefulWidget {
  final Book book;

  const BookReadingScreen({super.key, required this.book});

  @override
  _BookReadingScreenState createState() => _BookReadingScreenState();
}

class _BookReadingScreenState extends State<BookReadingScreen> {
  bool _showBars = true;
  int _currentChapterIndex = 0;
  PageController _pageController = PageController();

  void _toggleBars() {
    setState(() {
      _showBars = !_showBars;
    });
  }

  void _showContextMenu(BuildContext context, Offset position) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        position & const Size(40, 40), // smaller rect, the touch area
        Offset.zero & overlay.size, // Bigger rect, the entire screen
      ),
      items: [
        const PopupMenuItem<int>(value: 0, child: Text('Option 1')),
        const PopupMenuItem<int>(value: 1, child: Text('Option 2')),
        const PopupMenuItem<int>(value: 2, child: Text('Option 3')),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _showBars
          ? AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          iconSize: 20,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(widget.book.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            iconSize: 20,
            onPressed: () {
              // Handle search action
            },
          ),
          IconButton(
            icon: const Icon(Icons.font_download),
            iconSize: 20,
            onPressed: () {
              // Handle theme/font choosing action
            },
          ),
          PopupMenuButton<int>(
            onSelected: (item) => onSelected(context, item),
            itemBuilder: (context) => [
              const PopupMenuItem<int>(value: 0, child: Text('Option 1')),
              const PopupMenuItem<int>(value: 1, child: Text('Option 2')),
            ],
          ),
        ],
      )
          : null,
      body: GestureDetector(
        onTap: _toggleBars,
        child: PageView.builder(
          controller: _pageController,
          itemCount: widget.book.chapters.length,
          onPageChanged: (index) {
            setState(() {
              _currentChapterIndex = index;
            });
          },
          itemBuilder: (context, index) {
            final chapter = widget.book.chapters[index];
            return Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: ListView(
                children: [
                  Html(
                    data: chapter.htmlContent,
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: _showBars
          ? BottomAppBar(
        child: Container(
          height: 40, // Set a fixed height for the bottom navigation bar
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Chapter ${_currentChapterIndex + 1} of ${widget.book.chapters.length}'),
              Expanded(
                child: Slider(
                  value: _currentChapterIndex.toDouble(),
                  min: 0,
                  max: (widget.book.chapters.length - 1).toDouble(),
                  activeColor: Colors.black,
                  inactiveColor: Colors.grey,
                  onChanged: (value) {
                    setState(() {
                      _currentChapterIndex = value.toInt();
                      _pageController.jumpToPage(_currentChapterIndex);
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      )
          : null,
      floatingActionButton: _showBars
          ? FloatingActionButton(
        onPressed: () {
          // Handle magic wand action
        },
        backgroundColor: Colors.grey,
        foregroundColor: Colors.white,
        child: const Icon(Icons.auto_fix_high),
      )
          : null,
    );
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
      // Handle option 1
        break;
      case 1:
      // Handle option 2
        break;
    }
  }
}