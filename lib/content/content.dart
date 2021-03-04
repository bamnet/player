import 'dart:async';
import 'package:flutter/widgets.dart';

abstract class ConcertoContent {
  final Duration duration;
  final VoidCallback onFinish;
  final int id;

  ConcertoContent({this.id, this.duration, this.onFinish});

  Widget get widget;

  void play() {
    print("playing for $duration");
    new Timer(duration, this.onFinish);
  }

  void preload(BuildContext context) {}
}

class EmptyContent extends ConcertoContent {
  EmptyContent({Duration duration, VoidCallback onFinish})
      : super(duration: duration, onFinish: onFinish);

  Widget get widget {
    return SizedBox();
  }
}
