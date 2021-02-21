import 'dart:async';
import 'package:flutter/widgets.dart';

abstract class ConcertoContent {
  final Duration duration;
  final VoidCallback onFinish;

  ConcertoContent({this.duration, this.onFinish});

  Widget get widget;

  void play() {
    print("playing for $duration");
    new Timer(duration, this.onFinish);
  }

  void preload(BuildContext context) {}
}
