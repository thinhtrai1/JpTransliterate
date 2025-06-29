import 'package:flutter/widgets.dart';
import 'package:jp_transliterate/jp_transliterate.dart';

/// A widget that presents text alongside its transliteration, with subtle annotations elegantly positioned above—similar to Ruby Text in HTML.
class FuriganaText extends StatelessWidget {
  /// Creates a widget that presents text alongside its transliteration, with subtle annotations elegantly positioned above—similar to Ruby Text in HTML.
  const FuriganaText({
    Key? key,
    required this.transliterations,
    this.style,
    this.rubyStyle,
    this.textTransform,
    this.rubyTextTransform,
    this.spacing,
    this.textAlign,
    this.textDirection,
    this.softWrap,
    this.overflow,
    this.maxLines,
  }) : super(key: key);

  final List<TransliterationData> transliterations;
  final TextStyle? style;
  final TextStyle? rubyStyle;
  final String Function(TransliterationData data)? textTransform;
  final String Function(TransliterationData data)? rubyTextTransform;
  final double? spacing;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final bool? softWrap;
  final TextOverflow? overflow;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: transliterations.map((e) {
          final text = textTransform?.call(e) ?? e.kanji;
          if (text.startsWith('\n')) {
            return TextSpan(
              text: text,
              style: style,
            );
          }
          final ruby = rubyTextTransform?.call(e) ?? e.hiragana;
          final child = Text(text, style: style);
          return WidgetSpan(
            child: ruby.isNotEmpty && ruby != e.kanji
                ? Column(
                    children: [
                      Text(ruby, style: rubyStyle),
                      if (spacing != null) SizedBox(height: spacing),
                      child,
                    ],
                  )
                : child,
          );
        }).toList(),
      ),
      textAlign: textAlign,
      textDirection: textDirection,
      softWrap: softWrap,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}
