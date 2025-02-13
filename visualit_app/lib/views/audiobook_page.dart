import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:epubx/epubx.dart';
import 'dart:io';

class AudiobookPage extends StatefulWidget {
  const AudiobookPage({super.key});

  @override
  _AudiobookPageState createState() => _AudiobookPageState();
}

class _AudiobookPageState extends State<AudiobookPage> {
  final FlutterTts _flutterTts = FlutterTts();
  String _text = '';
  bool _isLoading = false;
  bool _isPlaying = false;
  double _speechRate = 0.5;

  Future<void> _pickFile() async {
    setState(() => _isLoading = true);
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['epub'],
    );

    if (result != null) {
      String? filePath = result.files.single.path;
      if (filePath != null) {
        await _extractTextFromEpub(filePath);
      }
    }
    setState(() => _isLoading = false);
  }

  Future<void> _extractTextFromEpub(String filePath) async {
    EpubBook epubBook = await EpubReader.readBook(await File(filePath).readAsBytes());
    String text = epubBook.Chapters?.map((chapter) => chapter.HtmlContent).join('\n') ?? '';
    setState(() {
      _text = _filterText(text);
    });
  }

  String _filterText(String text) {
    text = text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ''); // Remove HTML tags and entities
    text = text.replaceAll(RegExp(r'^\d+$', multiLine: true), ''); // Remove lines with only numbers
    text = text.replaceAll(RegExp(r'\b(Margin|Page|Header|Footer)\b.*', caseSensitive: false), ''); // Remove lines with specific words
    text = text.replaceAll(RegExp(r'@'), ''); // Remove @ signs
    text = text.replaceAll(RegExp(r'[^\w\s]', multiLine: true), ''); // Remove unwanted symbols
    return text;
  }

  Future<void> _speak() async {
    await _flutterTts.setSpeechRate(_speechRate);
    await _flutterTts.speak(_text);
    setState(() {
      _isPlaying = true;
    });
  }

  Future<void> _pause() async {
    await _flutterTts.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  Future<void> _stop() async {
    await _flutterTts.stop();
    setState(() {
      _isPlaying = false;
    });
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audiobook Player'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _pickFile,
              icon: const Icon(Icons.upload_file),
              label: const Text('Pick EPUB File'),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : Expanded(
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _text.isNotEmpty ? _text : 'No text loaded.',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, size: 36),
                  onPressed: _isPlaying ? _pause : _speak,
                  tooltip: _isPlaying ? 'Pause' : 'Play',
                ),
                IconButton(
                  icon: const Icon(Icons.stop, size: 36),
                  onPressed: _stop,
                  tooltip: 'Stop',
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
                      setState(() {
                        _speechRate = value;
                      });
                      await _flutterTts.setSpeechRate(value);
                      if (_isPlaying) {
                        await _speak(); // Restart speech with updated speed
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