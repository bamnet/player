import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:player/content/content.dart';
import 'package:intl/intl.dart';

class ConcertoTime extends ConcertoContent {
  ConcertoTime({Duration duration, VoidCallback onFinish})
      : super(duration: duration, onFinish: onFinish);

  ConcertoTimeWidget get widget {
    return new ConcertoTimeWidget();
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
    // TODO(bamnet): Make the sizing dynamic here.
    return Container(
        width: 500.0,
        height: 500.0,
        child: FittedBox(fit: BoxFit.fitWidth, child: Text(_time)));
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _time = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('hh:mm:ss').format(dateTime);
  }
}
