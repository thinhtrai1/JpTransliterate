import 'package:flutter/widgets.dart';
import 'package:jp_transliterate/jp_transliterate.dart';

/// A widget that presents text alongside its transliteration, with subtle annotations elegantly positioned above—similar to Ruby Text in HTML.
class TransliterationText extends StatelessWidget {
  /// Creates a widget that presents text alongside its transliteration, with subtle annotations elegantly positioned above—similar to Ruby Text in HTML.
  const TransliterationText({
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
          final children = <Widget>[];
          if (e.hiragana.isNotEmpty && e.hiragana != e.kanji) {
            children.add(Text(rubyTextTransform?.call(e) ?? e.hiragana, style: rubyStyle));
          }
          if (spacing != null) {
            children.add(SizedBox(height: spacing));
          }
          children.add(Text(text, style: style));
          return WidgetSpan(
            child: Column(
              children: children,
            ),
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
