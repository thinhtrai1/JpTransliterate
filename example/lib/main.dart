import 'package:flutter/material.dart';

import 'package:jp_transliterate/jp_transliterate.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _controller = TextEditingController(text: '日本の文化は長い歴史の中で発展してきました。京都や奈良には、昔の建築や芸術が多く残っています。伝統的な祭りや茶道、書道なども日本の文化を代表するものです。');
  TransliterationData? _transliterationData;
  List<TransliterationData>? _transliterationWords;

  @override
  void initState() {
    JpTransliterate.transliterate(kanji: _controller.text).then((value) {
      setState(() {
        _transliterationData = value;
      });
    });
    JpTransliterate.transliterateWords(kanji: _controller.text).then((value) {
      setState(() {
        _transliterationWords = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Transliterate example app'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Kanji'),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                minLines: 1,
                maxLines: 5,
                onChanged: (value) {
                  JpTransliterate.transliterate(kanji: value).then((value) {
                    setState(() {
                      _transliterationData = value;
                    });
                  });
                  JpTransliterate.transliterateWords(kanji: value).then((value) {
                    setState(() {
                      _transliterationWords = value;
                    });
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text('Hiragana'),
              _buildBackgroundText(
                child: Text(_transliterationData?.hiragana ?? ''),
              ),
              const SizedBox(height: 8),
              const Text('Katakana'),
              _buildBackgroundText(
                child: Text(_transliterationData?.katakana ?? ''),
              ),
              const SizedBox(height: 8),
              const Text('Romaji'),
              _buildBackgroundText(
                child: Text(_transliterationData?.romaji ?? ''),
              ),
              const SizedBox(height: 8),
              const Text('TransliterationText'),
              _buildBackgroundText(
                child: TransliterationText(
                  transliterations: _transliterationWords ?? [],
                  style: const TextStyle(fontSize: 16),
                  rubyStyle: const TextStyle(fontSize: 8),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundText({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFDDDDDD),
        borderRadius: BorderRadius.circular(4),
      ),
      width: double.infinity,
      child: child,
    );
  }
}
