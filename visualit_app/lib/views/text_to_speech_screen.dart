import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:epubx/epubx.dart' as epubx;
import 'package:image/image.dart' as img;

class AudiobookPage extends StatefulWidget {
  const AudiobookPage({super.key});

  @override
  _AudiobookPageState createState() => _AudiobookPageState();
}

class _AudiobookPageState extends State<AudiobookPage> {
  final FlutterTts _flutterTts = FlutterTts();
  List<String> _chapters = [];
  String _selectedChapterText = '';
  String? _bookName;
  MemoryImage? _bookCover;
  bool _isLoading = false;
  bool _isPlaying = false;
  double _speechRate = 0.5;

  @override
  void initState() {
    super.initState();
    _initializeTts();
  }

  void _initializeTts() {
    _flutterTts.setStartHandler(() => setState(() => _isPlaying = true));
    _flutterTts.setCompletionHandler(() => setState(() => _isPlaying = false));
    _flutterTts.setErrorHandler((_) => setState(() => _isPlaying = false));
  }

  Future<void> _pickFile() async {
    setState(() => _isLoading = true);
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['epub'],
      );

      if (result != null && result.files.single.path != null) {
        await _extractChaptersFromEpub(result.files.single.path!);
      }
    } catch (e) {
      _showError("Failed to load file.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _extractChaptersFromEpub(String filePath) async {
    try {
      epubx.EpubBook epubBook = await epubx.EpubReader.readBook(await File(filePath).readAsBytes());
      List<String> chapters = epubBook.Chapters?.map((c) => _filterText(c.HtmlContent ?? '')).toList() ?? [];

      setState(() {
        _chapters = chapters;
        _bookName = epubBook.Title;
        if (epubBook.CoverImage != null) {
          Uint8List coverBytes = Uint8List.fromList(img.encodePng(epubBook.CoverImage!));
          _bookCover = MemoryImage(coverBytes);
        }
      });
    } catch (e) {
      _showError("Error reading EPUB file.");
    }
  }

  String _filterText(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '');
  }

  Future<void> _speak(String text) async {
    await _flutterTts.setSpeechRate(_speechRate);
    await _flutterTts.speak(text);
  }

  Future<void> _pause() async {
    await _flutterTts.pause();
    setState(() => _isPlaying = false);
  }

  Future<void> _stop() async {
    await _flutterTts.stop();
    setState(() => _isPlaying = false);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Audiobook Reader')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              ElevatedButton(
                onPressed: _pickFile,
                child: _bookName == null
                    ? const Text('Pick EPUB File')
                    : Row(
                  children: [
                    if (_bookCover != null)
                      Image(image: _bookCover!, width: 50, height: 50, fit: BoxFit.cover),
                    const SizedBox(width: 10),
                    Expanded(child: Text(_bookName!, overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ),

            const SizedBox(height: 20),
            Expanded(
              child: _chapters.isEmpty
                  ? const Center(child: Text("No chapters available."))
                  : ListView.builder(
                itemCount: _chapters.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text('Chapter ${index + 1}'),
                      onTap: () {
                        setState(() => _selectedChapterText = _chapters[index]);
                        _speak(_selectedChapterText);
                      },
                    ),
                  );
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _pause,
                  icon: const Icon(Icons.pause),
                  label: const Text('Pause'),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: _stop,
                  icon: const Icon(Icons.stop),
                  label: const Text('Stop'),
                ),
              ],
            ),

            const SizedBox(height: 20),
            Row(
              children: [
                const Text('Speed:'),
                Expanded(
                  child: Slider(
                    value: _speechRate,
                    onChanged: (value) async {
                      setState(() => _speechRate = value);
                      await _flutterTts.setSpeechRate(value);
                      if (_isPlaying) {
                        await _speak(_selectedChapterText);
                      }
                    },
                    min: 0.1,
                    max: 1.0,
                    divisions: 9,
                    label: _speechRate.toStringAsFixed(1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
