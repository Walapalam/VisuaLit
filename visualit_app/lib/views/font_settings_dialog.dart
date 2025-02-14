import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';

class FontSettingsDialog extends StatefulWidget {
  final double initialTextSize;
  final TextAlign initialTextAlign;
  final double initialMargin;
  final double initialLineSpacing;
  final String initialFont;
  final Function(double) onBrightnessChanged;
  final Function(double) onTextSizeChanged;
  final Function(TextAlign) onTextAlignChanged;
  final Function(Color) onThemeColorChanged;
  final Function(double) onMarginChanged;
  final Function(double) onLineSpacingChanged;
  final Function(String) onFontChanged;

  const FontSettingsDialog({
    Key? key,
    required this.initialTextSize,
    required this.initialTextAlign,
    required this.initialMargin,
    required this.initialLineSpacing,
    required this.initialFont,
    required this.onBrightnessChanged,
    required this.onTextSizeChanged,
    required this.onTextAlignChanged,
    required this.onThemeColorChanged,
    required this.onMarginChanged,
    required this.onLineSpacingChanged,
    required this.onFontChanged,
  }) : super(key: key);

  @override
  _FontSettingsDialogState createState() => _FontSettingsDialogState();
}

class _FontSettingsDialogState extends State<FontSettingsDialog> {
  double _brightness = 1.0;
  double _textSize = 16.0;
  TextAlign _textAlign = TextAlign.left;
  Color _themeColor = Colors.white;
  bool _isExpanded = false;
  double _margin = 10.0;
  double _lineSpacing = 1.5;
  String _font = 'Default';

  @override
  void initState() {
    super.initState();
    _textSize = widget.initialTextSize;
    _textAlign = widget.initialTextAlign;
    _margin = widget.initialMargin;
    _lineSpacing = widget.initialLineSpacing;
    _font = widget.initialFont;
    _getCurrentBrightness();
  }

  Future<void> _getCurrentBrightness() async {
    double brightness = await ScreenBrightness().current;
    setState(() {
      _brightness = brightness;
    });
  }

  Future<void> _setBrightness(double brightness) async {
    await ScreenBrightness().setScreenBrightness(brightness);
    setState(() {
      _brightness = brightness;
      widget.onBrightnessChanged(brightness);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Flow Section
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Flow', style: TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              IconButton(
                                icon: Icon(Icons.view_agenda),
                                onPressed: () {
                                  // Handle paged view
                                },
                              ),
                              Text('Paged'),
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                icon: Icon(Icons.view_stream),
                                onPressed: () {
                                  // Handle scrolled view
                                },
                              ),
                              Text('Scrolled'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(),
                // Brightness Section
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Brightness', style: TextStyle(fontWeight: FontWeight.bold)),
                      Slider(
                        value: _brightness,
                        min: 0.0,
                        max: 1.0,
                        onChanged: (value) {
                          _setBrightness(value);
                        },
                      ),
                    ],
                  ),
                ),
                Divider(),
                // Theme and Text Settings Section
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Theme', style: TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(Icons.brightness_1, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                _themeColor = Colors.white;
                                widget.onThemeColorChanged(Colors.white);
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.brightness_1, color: Colors.black),
                            onPressed: () {
                              setState(() {
                                _themeColor = Colors.black;
                                widget.onThemeColorChanged(Colors.black);
                              });
                            },
                          ),
                          // Add more color options as needed
                        ],
                      ),
                      Text('Text Size', style: TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                _textSize = (_textSize - 2).clamp(10.0, 30.0);
                                widget.onTextSizeChanged(_textSize);
                              });
                            },
                          ),
                          Text('${_textSize.toInt()}'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                _textSize = (_textSize + 2).clamp(10.0, 30.0);
                                widget.onTextSizeChanged(_textSize);
                              });
                            },
                          ),
                        ],
                      ),
                      Text('Text Align', style: TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(Icons.format_align_left),
                            onPressed: () {
                              setState(() {
                                _textAlign = TextAlign.left;
                                widget.onTextAlignChanged(TextAlign.left);
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.format_align_center),
                            onPressed: () {
                              setState(() {
                                _textAlign = TextAlign.center;
                                widget.onTextAlignChanged(TextAlign.center);
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.format_align_right),
                            onPressed: () {
                              setState(() {
                                _textAlign = TextAlign.right;
                                widget.onTextAlignChanged(TextAlign.right);
                              });
                            },
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_isExpanded ? 'Less Settings' : 'More Settings'),
                            Icon(_isExpanded ? Icons.arrow_upward : Icons.arrow_downward),
                          ],
                        ),
                      ),
                      if (_isExpanded) ...[
                        Divider(),
                        Text('Margin', style: TextStyle(fontWeight: FontWeight.bold)),
                        Slider(
                          value: _margin,
                          min: 0.0,
                          max: 50.0,
                          onChanged: (value) {
                            setState(() {
                              _margin = value;
                              widget.onMarginChanged(value);
                            });
                          },
                        ),
                        Text('Line Spacing', style: TextStyle(fontWeight: FontWeight.bold)),
                        Slider(
                          value: _lineSpacing,
                          min: 1.0,
                          max: 2.0,
                          onChanged: (value) {
                            setState(() {
                              _lineSpacing = value;
                              widget.onLineSpacingChanged(value);
                            });
                          },
                        ),
                        Text('Font', style: TextStyle(fontWeight: FontWeight.bold)),
                        DropdownButton<String>(
                          value: _font,
                          items: <String>['Default', 'Serif', 'Sans-serif'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _font = value!;
                              widget.onFontChanged(value);
                            });
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}