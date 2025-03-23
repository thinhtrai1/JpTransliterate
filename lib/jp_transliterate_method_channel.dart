import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:jp_transliterate/jp_transliterate.dart';

import 'jp_transliterate_platform_interface.dart';

/// An implementation of [JpTransliteratePlatform] that uses method channels.
class MethodChannelJpTransliterate extends JpTransliteratePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('jp_transliterate');

  @override
  Future<TransliterationData> transliterate({
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
    final data = await methodChannel.invokeMethod('transliterate', {
      'kanji': kanji,
    });
    return TransliterationData(
      kanji: data?['kanji'] ?? kanji,
      romaji: data?['romaji'] ?? kanji,
      hiragana: data?['hiragana'] ?? kanji,
      katakana: data?['katakana'] ?? kanji,
    );
  }

  @override
  Future<List<TransliterationData>> transliterateWords({
    required String kanji,
  }) async {
    if (kanji.isEmpty) {
      return [
        TransliterationData(
        kanji: kanji,
        romaji: kanji,
        hiragana: kanji,
        katakana: kanji,
      ),];
    }
    final words = await methodChannel.invokeMethod('transliterateWords', {
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
}
