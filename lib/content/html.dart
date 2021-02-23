import 'package:flutter/widgets.dart';
import 'package:player/content/content.dart';
import 'package:easy_web_view/easy_web_view.dart';

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
    return EasyWebView(
      src: widget.html,
      isHtml: true,
      isMarkdown: false,
      convertToWidgets: false,
      onLoaded: () {},
    );
  }
}
