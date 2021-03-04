import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:player/content/content.dart';
import 'package:player/util.dart';

class ConcertoImage extends ConcertoContent {
  final String url;
  final String style;

  ConcertoImage(
      {Duration duration, VoidCallback onFinish, int id, this.style, this.url})
      : super(duration: duration, onFinish: onFinish, id: id);

  ConcertoImageWidget get widget {
    return new ConcertoImageWidget(
        key: ValueKey(this.id), url: this.url, style: this.style);
  }

  void preload(BuildContext context) {
    print("caching ${this.url}");
    precacheImage(_img(this.url).image, context);
  }
}

class ConcertoImageWidget extends StatefulWidget {
  ConcertoImageWidget({Key key, this.url, this.style}) : super(key: key);
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
