import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:player/content/content.dart';
import 'package:player/util.dart';

class ConcertoImage extends ConcertoContent {
  final String url;
  final String style;

  ConcertoImage(
      {@required Duration duration,
      @required VoidCallback onFinish,
      @required int id,
      @required this.style,
      @required this.url})
      : super(duration: duration, onFinish: onFinish, id: id);

  @override
  ConcertoImageWidget get widget {
    return ConcertoImageWidget(key: ValueKey(id), url: url, style: style);
  }

  @override
  void preload(BuildContext context) {
    print('caching $url');
    precacheImage(_img(url).image, context);
  }
}

class ConcertoImageWidget extends StatefulWidget {
  ConcertoImageWidget({Key key, @required this.url, @required this.style})
      : super(key: key);
  final String url;
  final String style;

  @override
  _ConcertoImageWidgetState createState() => _ConcertoImageWidgetState();
}

class _ConcertoImageWidgetState extends State<ConcertoImageWidget> {
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Container(
            decoration: cssToBoxDecoration(widget.style),
            child: _img(widget.url)));
  }
}

Image _img(String url) {
  return Image.network(url);
}
