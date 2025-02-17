import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/cupertino.dart';
import 'package:html/parser.dart' as htmlParser;
import '../core/models/book.dart';
import 'listening_screen_nav_bar_page.dart';
import 'audiobook_reading_page.dart';

class BookListeningScreen extends StatefulWidget {
  final Book book;
  final VoidCallback onClose;

  const BookListeningScreen({super.key, required this.book, required this.onClose});

  @override
  _BookListeningScreenState createState() => _BookListeningScreenState();
}

class _BookListeningScreenState extends State<BookListeningScreen> {
  final FlutterTts flutterTts = FlutterTts();
  bool isPlaying = false;
  bool isLooping = false;
  int currentChapterIndex = 0;
  double _speechRate = 1.0;
  int _selectedIndex = 0;
  double _currentPosition = 0.0;
  double _chapterDuration = 10.0;
  String _currentText = "";

  @override
  void initState() {
    super.initState();
    _setupTts();
    _loadChapter();
  }

  Future<void> _setupTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(_speechRate);

    flutterTts.setCompletionHandler(() async {
      if (mounted) {
        setState(() => isPlaying = false);
        if (isLooping) {
          _changeChapter(true);
        }
      }
    });

    flutterTts.setProgressHandler((String text, int start, int end, String word) {
      if (mounted) {
        setState(() {
          _currentPosition = start.toDouble();
        });
      }
    });
  }

  void _loadChapter() {
    setState(() {
      _currentText = _extractTextFromHtml(widget.book.chapters[currentChapterIndex].htmlContent);
      _chapterDuration = _calculateDuration(_currentText);
      _currentPosition = 0.0;
    });
  }

  double _calculateDuration(String text) {
    // Estimate duration based on text length and speech rate
    return text.length / (_speechRate * 10.0);
  }

  Future<void> _play() async {
    if (_currentText.isNotEmpty) {
      await flutterTts.speak(_currentText);
      setState(() => isPlaying = true);
    }
  }

  Future<void> _stop() async {
    await flutterTts.stop();
    setState(() {
      isPlaying = false;
      _currentPosition = 0.0;
    });
  }

  void _togglePlayPause() {
    isPlaying ? _stop() : _play();
  }

  void _changeChapter(bool next) {
    setState(() {
      if (next && currentChapterIndex < widget.book.chapters.length - 1) {
        currentChapterIndex++;
      } else if (!next && currentChapterIndex > 0) {
        currentChapterIndex--;
      }
      _loadChapter();
      if (isPlaying) _play();
    });
  }

  void _toggleLoop() {
    setState(() => isLooping = !isLooping);
  }

  Future<void> _setSpeechRate(double rate) async {
    setState(() => _speechRate = rate);
    await flutterTts.setSpeechRate(rate);
    _loadChapter(); // Recalculate duration with new speech rate
  }

  void _onNavBarItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) { // Lyrics option
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AudioBookReadingPage(
              book: widget.book,
              currentChapterIndex: currentChapterIndex,
              navBar: ListeningScreenNavBar(
                selectedIndex: _selectedIndex,
                onItemTapped: _onNavBarItemTapped,
              ),
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: widget.onClose,
        ),
        title: Text(widget.book.title, style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.book.coverImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 240,
                  height: 360,
                  child: widget.book.coverImage,
                ),
              ),
            SizedBox(height: 20),
            Text(
              widget.book.chapters[currentChapterIndex].title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 20),
            Slider(
              value: _currentPosition.clamp(0.0, _chapterDuration),
              min: 0,
              max: _chapterDuration,
              onChanged: (value) {
                setState(() {
                  _currentPosition = value;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDuration(_currentPosition)),
                Text(_formatDuration(_chapterDuration)),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<double>(
                  value: _speechRate,
                  items: [
                    DropdownMenuItem(value: 0.5, child: Text("0.5x")),
                    DropdownMenuItem(value: 1.0, child: Text("1.0x")),
                    DropdownMenuItem(value: 1.5, child: Text("1.5x")),
                    DropdownMenuItem(value: 2.0, child: Text("2.0x")),
                  ],
                  onChanged: (value) => _setSpeechRate(value ?? 1.0),
                ),
                SizedBox(width: 20),
                IconButton(
                  icon: Icon(CupertinoIcons.backward_fill, size: 36),
                  onPressed: () => _changeChapter(false),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: _togglePlayPause,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.black,
                    child: Icon(
                      isPlaying ? CupertinoIcons.pause_fill : CupertinoIcons.play_fill,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                IconButton(
                  icon: Icon(CupertinoIcons.forward_fill, size: 36),
                  onPressed: () => _changeChapter(true),
                ),
                SizedBox(width: 20),
                IconButton(
                  icon: Icon(isLooping ? CupertinoIcons.repeat_1 : CupertinoIcons.repeat, size: 36),
                  onPressed: _toggleLoop,
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: ListeningScreenNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onNavBarItemTapped,
      ),
    );
  }

  /// Strips HTML tags and extracts plain text for speech synthesis
  String _extractTextFromHtml(String htmlContent) {
    var document = htmlParser.parse(htmlContent);
    return document.body?.text ?? "";
  }

  /// Formats duration from seconds to mm:ss format
  String _formatDuration(double seconds) {
    final int minutes = (seconds / 60).floor();
    final int remainingSeconds = (seconds % 60).floor();
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}