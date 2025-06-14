import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:jp_transliterate/jp_transliterate.dart';

/// The main class of the package, which provides the main functionality of the package.
class JpTransliterate {
  const JpTransliterate._();

  static const _channel = MethodChannel('jp_transliterate');

  /// Transliterates the given [kanji] to [TransliterationData].
  static Future<TransliterationData> transliterate({
    required String kanji,
  }) async {
    if (kanji.isEmpty) {
      return TransliterationData(
        kanji: kanji,
        romaji: kanji,
        hiragana: kanji,
        katakana: kanji,
      );
    }
    final data = await _channel.invokeMethod('transliterate', {
      'kanji': kanji,
    });
    return TransliterationData(
      kanji: data?['kanji'] ?? kanji,
      romaji: data?['romaji'] ?? kanji,
      hiragana: data?['hiragana'] ?? kanji,
      katakana: data?['katakana'] ?? kanji,
    );
  }

  /// Transliterates the given [kanji] to a list of [TransliterationData].
  static Future<List<TransliterationData>> transliterateWords({
    required String kanji,
  }) async {
    if (kanji.isEmpty) {
      return [
        TransliterationData(
          kanji: kanji,
          romaji: kanji,
          hiragana: kanji,
          katakana: kanji,
        ),
      ];
    }
    final words = await _channel.invokeMethod('transliterateWords', {
      'kanji': kanji,
    });
    if (words == null) {
      return [];
    }
    return (words as List).map((data) {
      return TransliterationData(
        kanji: data?['kanji'] ?? "",
        romaji: data?['romaji'] ?? "",
        hiragana: data?['hiragana'] ?? "",
        katakana: data?['katakana'] ?? "",
      );
    }).toList();
  }

  /// Transliterates the given hiragana to katakana.
  static String katakanaToHiragana(String input) {
    return input.split('').map((char) {
      int code = char.codeUnitAt(0);
      return (code >= 0x30A1 && code <= 0x30FA) ? String.fromCharCode(code - 0x60) : char;
    }).join('');
  }

  /// Transliterates the given katakana to hiragana.
  static String hiraganaToKatakana(String input) {
    return input.split('').map((char) {
      int code = char.codeUnitAt(0);
      return (code >= 0x3041 && code <= 0x3096) ? String.fromCharCode(code + 0x60) : char;
    }).join('');
  }

  /// Transliterates the given katakana to romaji.
  static Future<String> katakanaToRomaji({
    required String katakana,
  }) async {
    final romaji = await _channel.invokeMethod('katakanaToRomaji', {
      'katakana': katakana,
    });
    return romaji ?? '';
  }

  /// Check if the [input] is predominantly kanji.
  ///
  /// The [confidenceThreshold] is a value between 0 and 1 that determines how many characters must be kanji to consider the input as kanji.
  static bool isKanji({
    required String input,
    double confidenceThreshold = 0.5,
  }) {
    return _check(input, confidenceThreshold, 0x4e00, 0x9faf);
  }

  /// Check if the [input] is predominantly hiragana.
  ///
  /// The [confidenceThreshold] is a value between 0 and 1 that determines how many characters must be hiragana to consider the input as hiragana.
  static bool isHiragana({
    required String input,
    double confidenceThreshold = 0.5,
  }) {
    return _check(input, confidenceThreshold, 0x3041, 0x3096);
  }

  /// Check if the [input] is predominantly katakana.
  ///
  /// The [confidenceThreshold] is a value between 0 and 1 that determines how many characters must be katakana to consider the input as katakana.
  static bool isKatakana({
    required String input,
    double confidenceThreshold = 0.5,
  }) {
    return _check(input, confidenceThreshold, 0x30a1, 0x30fc);
  }

  static bool _check(String input, double confidenceThreshold, int start, int end) {
    int total = 0;
    int match = 0;
    for (final char in input.characters) {
      final code = char.runes.first;
      // space and full-width space
      if (code == 0x0020 || code == 0x3000) continue;
      total++;
      if (start <= code && code <= end) {
        match++;
      }
    }
    if (total == 0) return false;
    return match >= total * confidenceThreshold;
  }
}
