import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:player/content/content.dart';

class ConcertoText extends ConcertoContent {
  final String text;
  ConcertoText({Duration duration, VoidCallback onFinish, this.text})
      : super(duration: duration, onFinish: onFinish);

  ConcertoTextWidget get widget {
    return new ConcertoTextWidget(text: text);
  }
}

class ConcertoTextWidget extends StatefulWidget {
  ConcertoTextWidget({Key key, this.text}) : super(key: key);
  final String text;

  @override
  _ConcertoTextWidgetState createState() => _ConcertoTextWidgetState();
}

class _ConcertoTextWidgetState extends State<ConcertoTextWidget> {
  @override
  Widget build(BuildContext context) {
    return FittedBox(
        fit: BoxFit.contain,
        child: Text(
          widget.text,
        ));
  }
}
