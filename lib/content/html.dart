import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:player/content/content.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:player/content/weather.dart';

class ConcertoHTML extends ConcertoContent {
  final String html;
  final String style;

  ConcertoHTML(
      {@required Duration duration,
      @required VoidCallback onFinish,
      @required int id,
      @required this.html,
      @required this.style})
      : super(duration: duration, onFinish: onFinish, id: id);

  @override
  ConcertoHTMLWidget get widget {
    return ConcertoHTMLWidget(key: ValueKey(id), html: html, style: style);
  }
}

class ConcertoHTMLWidget extends StatefulWidget {
  ConcertoHTMLWidget({Key key, @required this.html, @required this.style})
      : super(key: key);
  final String html;
  final String style;

  @override
  _ConcertoHTMLWidgetState createState() => _ConcertoHTMLWidgetState();
}

class _ConcertoHTMLWidgetState extends State<ConcertoHTMLWidget> {
  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      swapIcon(widget.html),
      webView: true,
      webViewMediaPlaybackAlwaysAllow: true,
    );
  }
}
