import 'package:flutter/widgets.dart';
import 'package:player/content/content.dart';

class ConcertoImage extends ConcertoContent {
  final String url;

  ConcertoImage({Duration duration, VoidCallback onFinish, this.url})
      : super(duration: duration, onFinish: onFinish);

  ConcertoImageWidget get widget {
    return new ConcertoImageWidget(url: this.url);
  }

  void preload(BuildContext context) {
    print("caching ${this.url}");
    precacheImage(_img(this.url).image, context);
  }
}

class ConcertoImageWidget extends StatefulWidget {
  ConcertoImageWidget({Key key, this.url}) : super(key: key);
  final String url;

  @override
  _ConcertoImageWidgetState createState() => _ConcertoImageWidgetState();
}

class _ConcertoImageWidgetState extends State<ConcertoImageWidget> {
  @override
  Widget build(BuildContext context) {
    return _img(widget.url);
  }
}

Image _img(String url) {
  return Image.network(
    url,
    fit: BoxFit.contain,
    height: double.infinity,
    width: double.infinity,
    alignment: Alignment.center,
  );
}
