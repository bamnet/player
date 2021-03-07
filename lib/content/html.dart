import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:player/content/content.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class ConcertoHTML extends ConcertoContent {
  final String html;
  final String style;

  ConcertoHTML(
      {Duration duration, VoidCallback onFinish, int id, this.html, this.style})
      : super(duration: duration, onFinish: onFinish, id: id);

  ConcertoHTMLWidget get widget {
    return new ConcertoHTMLWidget(
        key: ValueKey(this.id), html: this.html, style: this.style);
  }
}

class ConcertoHTMLWidget extends StatefulWidget {
  ConcertoHTMLWidget({Key key, this.html, this.style}) : super(key: key);
  final String html;
  final String style;

  @override
  _ConcertoHTMLWidgetState createState() => _ConcertoHTMLWidgetState();
}

class _ConcertoHTMLWidgetState extends State<ConcertoHTMLWidget> {
  @override
  Widget build(BuildContext context) {
    return HtmlWidget(widget.html);
  }
}
