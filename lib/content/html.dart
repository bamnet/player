// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:player/content/content.dart';
import 'package:easy_web_view/easy_web_view.dart';

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
    if (kIsWeb) {
      String viewId = _setup(src: widget.html, style: widget.style);
      return HtmlElementView(viewType: viewId);
    } else {
      return EasyWebView(
        src: '<style>*{${widget.style}}</style>${widget.html}',
        isHtml: true,
        isMarkdown: false,
        convertToWidgets: false,
        onLoaded: () {},
      );
    }
  }
}

String _setup({String src, String style}) {
  String id = "content-${src.length}";

  ui.platformViewRegistry.registerViewFactory(id, (int viewId) {
    final element = html.DivElement();
    element.innerHtml = src;
    element.attributes['style'] = style;
    return element;
  });

  return id;
}
