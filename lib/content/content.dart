import 'dart:async';
import 'package:flutter/widgets.dart';

abstract class ConcertoContent {
  final Duration? duration;
  final VoidCallback? onFinish;
  final int id;

  Timer? _finish;

  ConcertoContent(
      {required this.id, required this.duration, required this.onFinish});

  Widget get widget;

  void play() {
    print('playing for $duration');
    _finish = Timer(duration!, onFinish!);
  }

  void dispose() {
    if (_finish != null) {
      _finish!.cancel();
    }
  }

  void preload(BuildContext context) {}
}

class EmptyContent extends ConcertoContent {
  EmptyContent({Duration? duration, VoidCallback? onFinish})
      : super(id: -1, duration: duration, onFinish: onFinish);

  @override
  Widget get widget {
    return SizedBox();
  }
}
