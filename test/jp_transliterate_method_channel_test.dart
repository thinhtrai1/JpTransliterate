import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jp_transliterate/jp_transliterate_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelJpTransliterate platform = MethodChannelJpTransliterate();
  const MethodChannel channel = MethodChannel('jp_transliterate');

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
    final transliteration = await platform.transliterate(kanji: '警告表示');
    expect(transliteration.hiragana, 'けいこくひょうじ');
  });
}
