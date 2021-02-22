import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:player/content/content.dart';
import 'package:player/content/html.dart';
import 'package:player/content/image.dart';
import 'package:player/content/time.dart';
import 'package:player/content/video.dart';
import 'package:player/content_metadata.dart';

class Field extends StatefulWidget {
  Field({Key key}) : super(key: key);

  final List<ContentMetadata> original = [
    ContentMetadata(
        type: 'html', url: '<h1>Header</h1><div>Bo<strong>d</strong>y</div>'),
    ContentMetadata(type: 'time'),
    ContentMetadata(
        type: 'image',
        url: 'https://picsum.photos/600?image=1',
        duration: 1 + (new Random().nextInt(10))),
    ContentMetadata(
        type: 'video', url: 'https://www.youtube.com/watch?v=plJe0uDszaY'),
    ContentMetadata(
        type: 'image',
        url: 'https://picsum.photos/600/800?image=2',
        duration: 1 + (new Random().nextInt(10))),
    ContentMetadata(
        type: 'image',
        url: 'https://picsum.photos/600?image=3',
        duration: 1 + (new Random().nextInt(10))),
    ContentMetadata(
        type: 'image',
        url: 'https://picsum.photos/640/480?image=4',
        duration: 1 + (new Random().nextInt(10))),
    ContentMetadata(
        type: 'image',
        url: 'https://picsum.photos/600?image=5',
        duration: 1 + (new Random().nextInt(10))),
    ContentMetadata(
        type: 'image',
        url: 'https://picsum.photos/600?image=6',
        duration: 1 + (new Random().nextInt(10))),
    ContentMetadata(
        type: 'image',
        url: 'https://picsum.photos/600?image=7',
        duration: 1 + (new Random().nextInt(10))),
    ContentMetadata(
        type: 'image',
        url: 'https://picsum.photos/600?image=8',
        duration: 1 + (new Random().nextInt(10))),
    ContentMetadata(
        type: 'image',
        url: 'https://picsum.photos/1920/1080?image=10',
        duration: 1 + (new Random().nextInt(10))),
    ContentMetadata(
        type: 'image',
        url: 'https://picsum.photos/1920/1080?image=11',
        duration: 1 + (new Random().nextInt(10))),
  ];

  @override
  _FieldState createState() => _FieldState(original);
}

class _FieldState extends State<Field> {
  final List<ContentMetadata> original;
  ListQueue<ContentMetadata> list = ListQueue();

  Widget currentWidget = SizedBox(); // Placeholder widget.

  ConcertoContent currentContent;
  ConcertoContent nextContent;

  _FieldState(this.original) {
    list.addAll(this.original);
    this.nextContent = getNext();
  }

  // ignore: missing_return
  ConcertoContent getNext() {
    if (list.isEmpty) {
      list.addAll(original);
    }
    var item = list.first;
    list.removeFirst();

    switch (item.type) {
      case 'image':
        {
          return ConcertoImage(
            url: item.url,
            duration: Duration(seconds: item.duration),
            onFinish: this._moveNext,
          );
        }
        break;

      case 'video':
        {
          return ConcertoVideo(
            videoUrl: item.url,
            onFinish: this._moveNext,
          );
        }
        break;

      case 'time':
        {
          return ConcertoTime(
            duration: Duration(seconds: 10),
            onFinish: this._moveNext,
          );
        }
        break;

      case 'html':
        {
          return ConcertoHTML(
            html: item.url,
            duration: Duration(seconds: 10),
            onFinish: this._moveNext,
          );
        }
        break;
    }
  }

  void _moveNext() {
    this.currentContent = this.nextContent;

    setState(() {
      currentWidget = this.currentContent.widget;
    });
    this.currentContent.play();

    this.nextContent = getNext();
  }

  @override
  Widget build(BuildContext context) {
    this.nextContent.preload(context);

    return Scaffold(
      body: currentWidget,
      floatingActionButton: FloatingActionButton(
        onPressed: _moveNext,
        tooltip: 'Next',
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}
