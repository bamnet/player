import 'dart:collection';

import 'package:player/client/v2/client.dart' as api;
import 'package:flutter/material.dart';
import 'package:player/content/content.dart';
import 'package:player/content/html.dart';
import 'package:player/content/image.dart';
import 'package:player/content/text.dart';
import 'package:player/content/time.dart';
import 'package:player/content/video.dart';

class NoContentException implements Exception {}

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
  _FieldState createState() => _FieldState(client);
}

class _FieldState extends State<Field> {
  api.ConcertoV2Client _client;
  ListQueue<api.Content> list = ListQueue();

  _FieldState(this._client);

  Widget currentWidget = SizedBox(); // Placeholder widget.

  ConcertoContent currentContent;
  ConcertoContent nextContent;

  @override
  void initState() {
    super.initState();

    initialLoad();
  }

  void initialLoad() {
    print("Initial content load for field ${widget.id}.");
    _client.getContent(fieldContentPath: widget.fieldContentPath).then((value) {
      list.addAll(value);

      if (list.isNotEmpty) {
        nextContent = getNext();
        _moveNext();
      } else {
        print("No content found for field ${widget.id}");
      }
    });
  }

  void refresh() {
    print("Fetching content for field ${widget.id}");
    _client.getContent(fieldContentPath: widget.fieldContentPath).then((value) {
      list.addAll(value);
      // If we got content and we don't have any on-deck, queue it up.
      if (list.isNotEmpty && nextContent is EmptyContent) {
        nextContent = getNext();
      }
    });
  }

  ConcertoContent getNext() {
    if (list.length == 0) {
      throw new NoContentException();
    }

    var item = list.first;
    list.removeFirst();

    return convertContent(item);
  }

  void _moveNext() {
    // If we are running low on content, start refreshing more.
    if (list.length < 2) {
      refresh();
    }
    this.currentContent = this.nextContent;
    setState(() {
      currentWidget = this.currentContent.widget;
    });
    this.currentContent.play();

    // If we have more content available, queue it up.
    if (list.length > 1) {
      this.nextContent = getNext();
    } else {
      this.nextContent =
          EmptyContent(duration: Duration(seconds: 30), onFinish: _moveNext);
    }
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
