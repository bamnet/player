import 'package:flutter/widgets.dart';
import 'package:player/content/content.dart';
import 'package:flutter_html/flutter_html.dart';

class ConcertoHTML extends ConcertoContent {
  final String html;

  ConcertoHTML({Duration duration, VoidCallback onFinish, this.html})
      : super(duration: duration, onFinish: onFinish);

  ConcertoHTMLWidget get widget {
    return new ConcertoHTMLWidget(html: this.html);
  }
}

class ConcertoHTMLWidget extends StatefulWidget {
  ConcertoHTMLWidget({Key key, this.html}) : super(key: key);
  final String html;

  @override
  _ConcertoHTMLWidgetState createState() => _ConcertoHTMLWidgetState();
}

class _ConcertoHTMLWidgetState extends State<ConcertoHTMLWidget> {
  @override
  Widget build(BuildContext context) {
    return Html(data: widget.html);
  }
}
