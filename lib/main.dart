import 'package:flutter/material.dart';
import 'package:player/frontend.dart';
import 'package:player/settings.dart';
import 'package:player/settings_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSettings().init();
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
      home: MyHomePage(
        title: 'Concerto Player Demo',
      ),
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
  String baseUrl = AppSettings().baseUrl;
  int screenId = AppSettings().screenId;

  @override
  Widget build(BuildContext context) {
    print('Screen ID $screenId');
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              tooltip: 'Settings',
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
                setState(() {
                  baseUrl = AppSettings().baseUrl;
                  screenId = AppSettings().screenId;
                  print('Screen ID is now $screenId');
                });
              },
            )
          ],
        ),
        body: Frontend(
          baseURL: baseUrl,
          screenId: screenId,
        ));
  }
}
