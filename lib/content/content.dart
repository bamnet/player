import 'dart:async';
import 'package:flutter/widgets.dart';

abstract class ConcertoContent {
  final Duration duration;

  ConcertoContent({this.duration});

  Widget get widget;

  void play(VoidCallback onFinish) {
    print("playing for $duration");
    new Timer(duration, onFinish);
  }

  void preload(BuildContext context) {}
}
