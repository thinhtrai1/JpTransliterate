import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jp_transliterate/jp_transliterate.dart';

void main() {
  const channel = MethodChannel('jp_transliterate');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return {
          'kanji': '警告表示',
          'romaji': 'keikoku hyouji',
          'hiragana': 'けいこくひょうじ',
          'katakana': 'ケイコクヒョウジ',
        };
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('transliterate', () async {
    final transliteration = await JpTransliterate.transliterate(kanji: '警告表示');
    expect(transliteration.hiragana, 'けいこくひょうじ');
  });
}
