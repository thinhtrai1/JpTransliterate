# JP Transliterate

[![pub package](https://img.shields.io/pub/v/jp_transliterate.svg)](https://pub.dev/packages/jp_transliterate)

A Flutter plugin that converts Japanese Kanji into Furigana & Romaji, aiding language learners, reading assistance, and apps needing phonetic guides.

![](./Screenshot.png)

## Install
```yaml
dependencies:
  jp_transliterate: ^1.0.1
```

## Example

```dart
  final data = await JpTransliterate.transliterate(kanji: input);
  print('Data transliterated: $data');
```

## Features

- [x] Transliterate kanji to hiragana, katakana and romaji.
- [x] Transliterate kanji to list of words.
- [x] Transliterate hiragana to katakana and vice versa.
- [x] Transliterate katakana to romaji.
- [x] A TransliterationText widget that presents text with transliteration annotations positioned above.

## Roadmap

*No plan. If you have any ideas, please contribute.*

