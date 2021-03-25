import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:player/content_manager.dart';
import 'package:player/util.dart';

const transitionTime = Duration(milliseconds: 250);

class Field extends StatefulWidget {
  final String style;
  // TODO: Figure out what this config should be used for.
  final Map<String, dynamic> config;

  Field({Key key, @required this.style, @required this.config})
      : super(key: key);

  @override
  _FieldState createState() => _FieldState();
}

class _FieldState extends State<Field> {
  @override
  Widget build(BuildContext context) {
    var style = cssToTextStyle(widget.style);
    return DefaultTextStyle(
      style: DefaultTextStyle.of(context).style.merge(style),
      child: AnimatedSwitcher(
        duration: transitionTime,
        layoutBuilder: (Widget currentChild, List<Widget> previousChildren) {
          return Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: <Widget>[
              ...previousChildren,
              if (currentChild != null) currentChild,
            ],
          );
        },
        child: Consumer<ContentManager>(
            builder: (context, manager, child) => manager.content),
      ),
    );
  }
}
