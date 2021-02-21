import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:player/content/content.dart';
import 'package:player/content/image.dart';
import 'package:player/content/video.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Concerto Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  final List<String> original = [
    'https://picsum.photos/600?image=1',
    'xTczn5RUgnk',
    'https://picsum.photos/600/800?image=2',
    'https://picsum.photos/600?image=3',
    'https://picsum.photos/640/480?image=4',
    'https://picsum.photos/600?image=5',
    'https://picsum.photos/600?image=6',
    'https://picsum.photos/600?image=7',
    'https://picsum.photos/600?image=8',
    'https://picsum.photos/1920/1080?image=10',
    'https://picsum.photos/1920/1080?image=11',
  ];

  @override
  _MyHomePageState createState() => _MyHomePageState(original);
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> original;
  ListQueue<String> list = ListQueue();

  Widget currentWidget = SizedBox(); // Placeholder widget.

  ConcertoContent currentContent;
  ConcertoContent nextContent;

  _MyHomePageState(this.original) {
    list.addAll(this.original);
    this.nextContent = getNext();
  }

  ConcertoContent getNext() {
    if (list.isEmpty) {
      list.addAll(original);
    }
    String url = list.first;
    list.removeFirst();

    if (url.length > 20) {
      return ConcertoImage(
        url: url,
        duration: Duration(seconds: 1 + (new Random().nextInt(10))),
        onFinish: this._moveNext,
      );
    } else {
      return ConcertoVideo(
        videoUrl: 'https://www.youtube.com/watch?v=plJe0uDszaY',
        onFinish: this._moveNext,
      );
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
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: currentWidget,
      floatingActionButton: FloatingActionButton(
        onPressed: _moveNext,
        tooltip: 'Next',
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}
