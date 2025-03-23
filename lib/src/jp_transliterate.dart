import 'package:jp_transliterate/jp_transliterate.dart';
import 'package:jp_transliterate/jp_transliterate_platform_interface.dart';

/// The main class of the package, which provides the main functionality of the package.
class JpTransliterate {
  const JpTransliterate._();

  /// Transliterates the given [kanji] to [TransliterationData].
  static Future<TransliterationData> transliterate({
    required String kanji,
  }) {
    return JpTransliteratePlatform.instance.transliterate(kanji: kanji);
  }

  /// Transliterates the given [kanji] to a list of [TransliterationData].
  static Future<List<TransliterationData>> transliterateWords({
    required String kanji,
  }) {
    return JpTransliteratePlatform.instance.transliterateWords(kanji: kanji);
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
  }) {
    return JpTransliteratePlatform.instance.katakanaToRomaji(katakana: katakana);
  }
}
