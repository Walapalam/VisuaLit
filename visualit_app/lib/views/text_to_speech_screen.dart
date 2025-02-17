import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:epubx/epubx.dart' as epubx;
import 'dart:io';
import 'dart:convert'; // Import for base64Encode
import 'package:image/image.dart' as img; // Alias for image package
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';

class AudiobookPage extends StatefulWidget {
  const AudiobookPage({super.key});

  @override
  _AudiobookPageState createState() => _AudiobookPageState();
}

class _AudiobookPageState extends State<AudiobookPage> {
  final FlutterTts _flutterTts = FlutterTts();
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<String> _chapters = [];
  String _selectedChapterText = '';
  String? _bookName;
  MemoryImage? _bookCover;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeTts();
  }

  void _initializeTts() {
    _flutterTts.setStartHandler(() {
      setState(() {
        // TTS started
      });
    });

    _flutterTts.setCompletionHandler(() {
      setState(() {
        // TTS completed
      });
    });

    _flutterTts.setErrorHandler((msg) {
      setState(() {
        // TTS error
      });
    });
  }

  Future<void> _pickFile() async {
    setState(() {
      _isLoading = true;
    });

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'epub'],
    );

    if (result != null) {
      String? filePath = result.files.single.path;
      if (filePath != null) {
        if (filePath.endsWith('.pdf')) {
          return;
        } else if (filePath.endsWith('.epub')) {
          await _extractChaptersFromEpub(filePath);
        }
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _extractChaptersFromEpub(String filePath) async {
    epubx.EpubBook epubBook = await epubx.EpubReader.readBook(await File(filePath).readAsBytes());
    List<String> chapters = epubBook.Chapters?.skip(1).map((chapter) => _filterText(chapter.HtmlContent ?? '')).toList() ?? [];
    setState(() {
      _chapters = chapters;
      _bookName = epubBook.Title;
      if (epubBook.CoverImage != null) {
        // Convert the Image object to Uint8List
        img.Image coverImage = epubBook.CoverImage!;
        Uint8List coverBytes = Uint8List.fromList(img.encodePng(coverImage));
        _bookCover = MemoryImage(coverBytes);
      }
    });
  }

  String _filterText(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ''); // Remove HTML tags and entities
  }

  Future<void> _speak(String text) async {
    await _flutterTts.stop(); // Stop any ongoing speech
    await _flutterTts.speak(text);
  }
/*
  Future<void> _fetchAndPlayTts(String text) async {
    final response = await http.post(
      Uri.parse('http://your-fastapi-backend-url/tts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'text': text}),
    );

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/tts_audio.mp3');
      await file.writeAsBytes(bytes);
      await _audioPlayer.play(file.path, isLocal: true);
    } else {
      // Handle error
    }
  }
 */

  Future<void> _pause() async {
    await _flutterTts.pause();
    await _audioPlayer.pause();
  }

  Future<void> _stop() async {
    await _flutterTts.stop();
    await _audioPlayer.stop();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _audioPlayer.dispose();
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
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _pickFile,
              child: _bookName == null
                  ? const Text('Pick PDF or EPUB File')
                  : Row(
                children: [
                  if (_bookCover != null)
                    Image(
                      image: _bookCover!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  const SizedBox(width: 10),
                  Text(_bookName!),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _chapters.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Chapter ${index + 1}'),
                    onTap: () {
                      setState(() {
                        _selectedChapterText = _chapters[index];
                      });
                      Future.microtask(() => _speak(_selectedChapterText));
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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