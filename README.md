# JP Transliterate

[![pub package](https://img.shields.io/pub/v/jp_transliterate.svg)](https://pub.dev/packages/jp_transliterate)

A Flutter plugin that converts Japanese Kanji text into Furigana and Romaji. This is useful for language learners, reading assistance, and applications that require phonetic guides for Japanese text.

![](./Screenshot.png)

## Install
```yaml
dependencies:
  jp_transliterate: ^0.0.1
```

## Example

```dart
  final data = await JpTransliterate.transliterate(kanji: input);
  print('Data transliterated: $data');
```

## Features

- [x] Transliterate kanji to hiragana.
- [x] Transliterate kanji to katakana.
- [x] Transliterate kanji to romaji.
- [x] Transliterate kanji to list of words.
- [x] Transliterate hiragana to katakana and vice versa.
- [x] A TransliterationText widget that presents text with transliteration annotations positioned above.

## Roadmap

*No plan. If you have any ideas, please contribute.*

