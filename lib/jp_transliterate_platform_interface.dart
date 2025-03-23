import 'package:jp_transliterate/jp_transliterate.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'jp_transliterate_method_channel.dart';

abstract class JpTransliteratePlatform extends PlatformInterface {
  /// Constructs a JpTransliteratePlatform.
  JpTransliteratePlatform() : super(token: _token);

  static final Object _token = Object();

  static JpTransliteratePlatform _instance = MethodChannelJpTransliterate();

  /// The default instance of [JpTransliteratePlatform] to use.
  ///
  /// Defaults to [MethodChannelJpTransliterate].
  static JpTransliteratePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [JpTransliteratePlatform] when
  /// they register themselves.
  static set instance(JpTransliteratePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<TransliterationData> transliterate({
    required String kanji,
  }) {
    throw UnimplementedError('transliterate() has not been implemented.');
  }

  Future<List<TransliterationData>> transliterateWords({
    required String kanji,
  }) {
    throw UnimplementedError('transliterate() has not been implemented.');
  }
}
