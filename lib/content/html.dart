import 'package:flutter/widgets.dart';
import 'package:player/content/content.dart';
import 'package:easy_web_view/easy_web_view.dart';

class ConcertoHTML extends ConcertoContent {
  final String html;
  final String style;

  ConcertoHTML(
      {Duration duration, VoidCallback onFinish, this.html, this.style})
      : super(duration: duration, onFinish: onFinish);

  ConcertoHTMLWidget get widget {
    return new ConcertoHTMLWidget(html: this.html, style: this.style);
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
    return EasyWebView(
      src: '<style>*{${widget.style}}</style>${widget.html}',
      isHtml: true,
      isMarkdown: false,
      convertToWidgets: false,
      onLoaded: () {},
    );
  }
}
