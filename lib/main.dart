import 'package:flutter/material.dart';
import 'package:player/field.dart';

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
      home: MyHomePage(title: 'Concerto Player Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        double w = constraints.maxWidth;
        double h = constraints.maxHeight;
        return Stack(children: [
          Positioned.fill(
            child: Image(
              image: AssetImage('BlueSwooshNeo_16x9.jpg'),
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            left: 0.024 * w,
            top: 0.885 * h,
            width: 0.156 * w,
            height: 0.089 * h,
            child: Field(),
          ),
          Positioned(
            left: 0.025 * w,
            top: 0.026 * h,
            width: 0.567 * w,
            height: 0.77 * h,
            child: Field(),
          ),
          Positioned(
            left: 0.68 * w,
            top: 0.015 * h,
            width: 0.3 * w,
            height: 0.796 * h,
            child: Field(),
          ),
          Positioned(
            left: 0.221 * w,
            top: 0.885 * h,
            width: 0.754 * w,
            height: 0.1 * h,
            child: Field(),
          )
        ]);
      }),
    );
  }
}
