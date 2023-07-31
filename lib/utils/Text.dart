import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tch_appliable_core/src/core/Translator.dart';

/// Truncate text for limit, optionally find nearest whitespace for whole words
String truncateText(
  String text,
  int limit, {
  bool wholeWords = false,
  bool addDots = false,
  bool addSpaceDots = false,
}) {
  if (text.length > limit) {
    if (wholeWords && text.contains(' ')) {
      final String part = text.substring(0, limit);
      final int whitespace = part.lastIndexOf(' ');

      return part.substring(0, whitespace) +
          (addDots ? (addSpaceDots ? ' ...' : '...') : '');
    } else {
      return text.substring(0, limit) +
          (addDots ? (addSpaceDots ? ' ...' : '...') : '');
    }
  }

  return text;
}

/// Parse text for links and return as RichText if at least one, else pure text
Widget textWithLinks(
  String text, {
  TextStyle? textStyle,
  RegExp? exp,
  TextStyle? linkTextStyle,
  required void Function(String link) onTapLink,
}) {
  exp ??= RegExp(
      r'(http|ftp|https)://([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?');

  if (exp.hasMatch(text)) {
    List<TextSpan> spans = [];
    int start = 0;
    final List<RegExpMatch> matches = exp.allMatches(text).toList();

    for (RegExpMatch match in matches) {
      if (match.start > 0) {
        spans.add(TextSpan(
          text: text.substring(start, match.start),
          style: textStyle,
        ));
      }

      spans.add(
        TextSpan(
          text: text.substring(match.start, match.end),
          style: linkTextStyle,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              onTapLink(text.substring(match.start, match.end));
            },
        ),
      );

      start = match.end;
    }

    if (start < text.length) {
      spans.add(TextSpan(
        text: text.substring(start),
        style: textStyle,
      ));
    }

    return Text.rich(
      TextSpan(children: spans),
      textAlign: TextAlign.left,
    );
  }

  return Text(
    text,
    style: textStyle,
  );
}

/// Convert milliseconds since epoch to default formatted text, requires enabled Translator
String millisToDefault(int millis, {bool time = true}) {
  if (time) {
    return Translator.instance!.localizedDateTimeFormat
        .format(DateTime.fromMillisecondsSinceEpoch(millis));
  } else {
    return Translator.instance!.localizedDateFormat
        .format(DateTime.fromMillisecondsSinceEpoch(millis));
  }
}
