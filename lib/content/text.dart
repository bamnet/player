import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:player/content/content.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class ConcertoText extends ConcertoContent {
  final String text;
  ConcertoText(
      {required Duration duration,
      required VoidCallback onFinish,
      required int id,
      required this.text})
      : super(duration: duration, onFinish: onFinish, id: id);

  @override
  ConcertoTextWidget get widget {
    return ConcertoTextWidget(key: ValueKey(id), text: text);
  }
}

class ConcertoTextWidget extends StatefulWidget {
  ConcertoTextWidget({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  _ConcertoTextWidgetState createState() => _ConcertoTextWidgetState();
}

class _ConcertoTextWidgetState extends State<ConcertoTextWidget> {
  @override
  Widget build(BuildContext context) {
    return FittedBox(
        fit: BoxFit.contain,
        // Text elements may contain basic HTML elements
        // rendered from Markdown. To support this, we
        // use a library which converts them into native widgets.
        child: HtmlWidget(
          widget.text.trim(),
        ));
  }
}
