import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../core/models/book.dart';
import '../core/models/book_metadata.dart';
import '../core/services/epub_service.dart';
import 'font_settings_dialog.dart';

class BookReadingScreen extends StatefulWidget {
  final BookMetadata bookMetadata;

  const BookReadingScreen({super.key, required this.bookMetadata});

  @override
  _BookReadingScreenState createState() => _BookReadingScreenState();
}

class _BookReadingScreenState extends State<BookReadingScreen> {
  late Future<Book> _bookFuture;
  final EpubService _epubService = EpubService();
  bool _showBars = true;
  int _currentChapterIndex = 0;
  late PageController _pageController;
  double _brightness = 1.0;
  double _textSize = 16.0;
  TextAlign _textAlign = TextAlign.left;
  Color _themeColor = Colors.white;
  double _margin = 10.0;
  double _lineSpacing = 1.5;
  String _font = 'Default';

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentChapterIndex);
    _bookFuture = _epubService.loadBook(widget.bookMetadata.filePath);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _toggleBars() {
    setState(() {
      _showBars = !_showBars;
    });
  }

  void _showFontSettingsDialog() {
    setState(() {
      _showBars = false;
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: FontSettingsDialog(
            initialTextSize: _textSize,
            initialTextAlign: _textAlign,
            initialMargin: _margin,
            initialLineSpacing: _lineSpacing,
            initialFont: _font,
            onBrightnessChanged: (value) {
              setState(() {
                _brightness = value;
              });
            },
            onTextSizeChanged: (value) {
              setState(() {
                _textSize = value;
              });
            },
            onTextAlignChanged: (value) {
              setState(() {
                _textAlign = value;
              });
            },
            onThemeColorChanged: (value) {
              setState(() {
                _themeColor = value;
              });
            },
            onMarginChanged: (value) {
              setState(() {
                _margin = value;
              });
            },
            onLineSpacingChanged: (value) {
              setState(() {
                _lineSpacing = value;
              });
            },
            onFontChanged: (value) {
              setState(() {
                _font = value;
              });
            },
          ),
        );
      },
    ).then((_) {
      setState(() {
        _showBars = true;
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Book>(
      future: _bookFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('No data available'));
        }

        final book = snapshot.data!;

        return Scaffold(
          appBar: _showBars
              ? AppBar(
            backgroundColor: Colors.grey[200],
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              iconSize: 20,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(widget.bookMetadata.title),
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
                onPressed: _showFontSettingsDialog,
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
          body: PageView.builder(
            controller: _pageController,
            itemCount: book.chapters.length,
            onPageChanged: (index) {
              setState(() {
                _currentChapterIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final chapter = book.chapters[index];
              return Container(
                color: Colors.white,
                child: GestureDetector(
                  onTap: _toggleBars,
                  behavior: HitTestBehavior.opaque,
                  child: SingleChildScrollView(
                    child: Html(
                      data: chapter.htmlContent,
                      style: {
                        "body": Style(
                          fontSize: FontSize(_textSize),
                          textAlign: _textAlign,
                          backgroundColor: Colors.white,
                          lineHeight: LineHeight(_lineSpacing),
                          fontFamily: _font,
                          margin: Margins.symmetric(horizontal: _margin),
                        ),
                      },
                    ),
                  ),
                ),
              );
            },
          ),
          bottomNavigationBar: _showBars
              ? BottomAppBar(
            color: Colors.grey[200],
            child: SizedBox(
              height: 40,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Chapter ${_currentChapterIndex + 1} of ${book.chapters.length}'),
                  Expanded(
                    child: Slider(
                      value: _currentChapterIndex.toDouble(),
                      min: 0,
                      max: (book.chapters.length - 1).toDouble(),
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
              ? SpeedDial(
            backgroundColor: Colors.grey,
            foregroundColor: Colors.white,
            icon: Icons.auto_fix_high,
            activeIcon: Icons.close,
            children: [
              SpeedDialChild(
                child: const Icon(Icons.search, color: Colors.white),
                label: 'Look up',
                onTap: () {
                  // Handle look up action
                },
              ),
              SpeedDialChild(
                child: const Icon(Icons.headset, color: Colors.white),
                label: 'Listen',
                onTap: () {
                  // Handle listen action
                },
              ),
              SpeedDialChild(
                child: const Icon(Icons.visibility, color: Colors.white),
                label: 'Visualize',
                onTap: () {
                  // Handle visualize action
                },
              ),
            ],
          )
              : null,
        );
      },
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