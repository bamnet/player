import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:player/content/content.dart';
import 'package:intl/intl.dart';

class ConcertoTime extends ConcertoContent {
  ConcertoTime({@required Duration duration, @required VoidCallback onFinish})
      : super(id: 0, duration: duration, onFinish: onFinish);

  @override
  ConcertoTimeWidget get widget {
    return ConcertoTimeWidget();
  }
}

class ConcertoTimeWidget extends StatefulWidget {
  ConcertoTimeWidget({Key key}) : super(key: key);

  @override
  _ConcertoTimeWidgetState createState() => _ConcertoTimeWidgetState();
}

class _ConcertoTimeWidgetState extends State<ConcertoTimeWidget> {
  String _time;
  Timer timer;

  @override
  void initState() {
    _time = _formatDateTime(DateTime.now());
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(fit: BoxFit.contain, child: Text(_time));
  }

  void _getTime() {
    final now = DateTime.now();
    final formattedDateTime = _formatDateTime(now);
    setState(() {
      _time = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('hh:mm:ss').format(dateTime);
  }
}
