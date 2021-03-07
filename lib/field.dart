import 'package:flutter/material.dart';
import 'package:player/client/v2/client.dart' as api;
import 'package:player/content/converter.dart';
import 'package:player/content_manager.dart';
import 'package:player/content/content.dart';
import 'package:player/util.dart';

const transitionTime = Duration(milliseconds: 250);

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
  _FieldState createState() => _FieldState(client, fieldContentPath, name);
}

class _FieldState extends State<Field> {
  api.ConcertoV2Client _client;
  ContentManager _contentManager;

  _FieldState(this._client, String fieldContentPath, String fieldName) {
    this._contentManager = ContentManager(
        client: _client,
        fieldContentPath: fieldContentPath,
        fieldName: fieldName,
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
      return convert(
          item: item,
          onFinish: _moveNext,
          baseURL: _client.baseURL,
          style: widget.style);
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

    TextStyle style = cssToTextStyle(widget.style);
    return DefaultTextStyle(
      style: DefaultTextStyle.of(context).style.merge(style),
      child: AnimatedSwitcher(
        child: currentWidget,
        duration: transitionTime,
        layoutBuilder: (Widget currentChild, List<Widget> previousChildren) {
          return Stack(
            children: <Widget>[
              ...previousChildren,
              if (currentChild != null) currentChild,
            ],
            alignment: Alignment.center,
            fit: StackFit.expand,
          );
        },
      ),
    );
  }
}
