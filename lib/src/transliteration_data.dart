/// Data class for transliteration data.
class TransliterationData {
  const TransliterationData({
    required this.kanji,
    required this.romaji,
    required this.hiragana,
    required this.katakana,
  });

  /// Original in kanji.
  final String kanji;

  /// The transliterated romaji from [kanji].
  final String romaji;

  /// The transliterated hiragana from [kanji].
  final String hiragana;

  /// The transliterated katakana from [kanji].
  final String katakana;

  TransliterationData copyWith({
    String? kanji,
    String? romaji,
    String? hiragana,
    String? katakana,
  }) {
    return TransliterationData(
      kanji: kanji ?? this.kanji,
      romaji: romaji ?? this.romaji,
      hiragana: hiragana ?? this.hiragana,
      katakana: katakana ?? this.katakana,
    );
  }

  @override
  String toString() {
    return 'TransliterationData{kanji: $kanji, romaji: $romaji, hiragana: $hiragana, katakana: $katakana}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransliterationData &&
          runtimeType == other.runtimeType &&
          kanji == other.kanji &&
          romaji == other.romaji &&
          hiragana == other.hiragana &&
          katakana == other.katakana;

  @override
  int get hashCode => kanji.hashCode ^ romaji.hashCode ^ hiragana.hashCode ^ katakana.hashCode;
}
