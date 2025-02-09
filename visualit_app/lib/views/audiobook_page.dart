import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdf_text/pdf_text.dart';
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

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'epub'],
    );

    if (result != null) {
      String? filePath = result.files.single.path;
      if (filePath != null) {
        if (filePath.endsWith('.pdf')) {
          await _extractTextFromPdf(filePath);
        } else if (filePath.endsWith('.epub')) {
          await _extractTextFromEpub(filePath);
        }
      }
    }
  }

  Future<void> _extractTextFromPdf(String filePath) async {
    PDFDoc doc = await PDFDoc.fromPath(filePath);
    String text = await doc.text;
    setState(() {
      _text = _filterText(text);
    });
  }

  Future<void> _extractTextFromEpub(String filePath) async {
    EpubBook epubBook = await EpubReader.readBook(await File(filePath).readAsBytes());
    String text = epubBook.Chapters?.map((chapter) => chapter.HtmlContent).join('\n') ?? '';
    setState(() {
      _text = _filterText(text);
    });
  }

  String _filterText(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ''); // Remove HTML tags and entities
  }

  Future<void> _speak() async {
    await _flutterTts.speak(_text);
  }

  Future<void> _pause() async {
    await _flutterTts.pause();
  }

  Future<void> _play() async {
    await _flutterTts.speak(_text);
  }

  Future<void> _stop() async {
    await _flutterTts.stop();
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
        title: const Text('Audiobook Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _pickFile,
              child: const Text('Pick PDF or EPUB File'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_text),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _play,
                  child: const Text('Play'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _pause,
                  child: const Text('Pause'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _stop,
                  child: const Text('Stop'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}