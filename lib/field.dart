import 'package:flutter/material.dart';
import 'package:player/client/v2/client.dart' as api;
import 'package:player/content_manager.dart';
import 'package:player/content/content.dart';
import 'package:player/content/html.dart';
import 'package:player/content/image.dart';
import 'package:player/content/text.dart';
import 'package:player/content/time.dart';
import 'package:player/content/video.dart';

class Field extends StatefulWidget {
  final api.ConcertoV2Client client;
  final int id;
  final String name;
  final String fieldContentPath;
  final String style;
  final Map<String, dynamic> config;

  Field(
      {Key key,
      this.client,
      this.id,
      this.name,
      this.fieldContentPath,
      this.style,
      this.config})
      : super(key: key);

  @override
  _FieldState createState() => _FieldState(client, fieldContentPath);
}

class _FieldState extends State<Field> {
  api.ConcertoV2Client _client;
  ContentManager _contentManager;

  _FieldState(this._client, String fieldContentPath) {
    this._contentManager = ContentManager(
        client: _client,
        fieldContentPath: fieldContentPath,
        onRefill: recoveryFromEmpty);
    this._contentManager.refresh();
  }

  Widget currentWidget = SizedBox(); // Placeholder widget.

  ConcertoContent currentContent;
  ConcertoContent nextContent;

  void recoveryFromEmpty() {
    if (currentContent == null) {
      print("Recovering from empty queue by populating current.");
      nextContent = getNext();
      _moveNext();
    }

    if (this.nextContent == null) {
      print("Recovering from empty queue by populating next.");
      nextContent = getNext();
    }
  }

  ConcertoContent getNext() {
    try {
      var item = _contentManager.next;
      return convertContent(item);
    } on NoContentException {
      return null;
    }
  }

  void _moveNext() {
    this.currentContent = this.nextContent;

    setState(() {
      if (this.currentContent == null) {
        currentWidget = SizedBox();
      } else {
        currentWidget = this.currentContent.widget;
      }
    });
    if (this.currentContent != null) {
      this.currentContent.play();
    }

    this.nextContent = getNext();
  }

  @override
  Widget build(BuildContext context) {
    if (this.nextContent != null) {
      this.nextContent.preload(context);
    }

    return currentWidget;
  }

  ConcertoContent convertContent(api.Content item) {
    switch (item.type) {
      case 'Graphic':
        {
          return ConcertoImage(
            url: "${_client.baseURL}${item.renderDetails['path']}",
            duration: Duration(seconds: item.duration),
            onFinish: this._moveNext,
          );
        }
        break;

      case 'Ticker':
        {
          return ConcertoText(
            text: item.renderDetails['data'],
            duration: Duration(seconds: item.duration),
            onFinish: this._moveNext,
          );
        }
        break;

      case 'HtmlText':
        {
          return ConcertoHTML(
            html: item.renderDetails['data'],
            duration: Duration(seconds: item.duration),
            onFinish: this._moveNext,
          );
        }
        break;

      case 'zz_video':
        {
          return ConcertoVideo(
            videoUrl: "",
            onFinish: this._moveNext,
          );
        }
        break;

      case 'zz_time':
        {
          return ConcertoTime(
            duration: Duration(seconds: 10),
            onFinish: this._moveNext,
          );
        }
        break;
    }

    return EmptyContent(
      duration: Duration(seconds: 10),
      onFinish: this._moveNext,
    );
  }
}
