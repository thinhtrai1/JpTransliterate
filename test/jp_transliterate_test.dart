import 'package:flutter_test/flutter_test.dart';
import 'package:jp_transliterate/jp_transliterate.dart';
import 'package:jp_transliterate/jp_transliterate_platform_interface.dart';
import 'package:jp_transliterate/jp_transliterate_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockJpTransliteratePlatform
    with MockPlatformInterfaceMixin
    implements JpTransliteratePlatform {
  @override
  Future<TransliterationData> transliterate({
    required String kanji,
  }) async {
    return const TransliterationData(
      kanji: '警告表示',
      romaji: 'keikoku hyouji',
      hiragana: 'けいこくひょうじ',
      katakana: 'ケイコクヒョウジ',
    );
  }

  @override
  Future<List<TransliterationData>> transliterateWords({required String kanji}) {
    throw UnimplementedError();
  }

  @override
  Future<String> katakanaToRomaji({required String katakana}) {
    throw UnimplementedError();
  }
}

void main() {
  final JpTransliteratePlatform initialPlatform = JpTransliteratePlatform.instance;

  test('$MethodChannelJpTransliterate is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelJpTransliterate>());
  });

  test('transliterate', () async {
    MockJpTransliteratePlatform fakePlatform = MockJpTransliteratePlatform();
    JpTransliteratePlatform.instance = fakePlatform;
    final transliteration = await JpTransliterate.transliterate(kanji: '警告表示');
    expect(transliteration.hiragana, 'けいこくひょうじ');
  });
}
