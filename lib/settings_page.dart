import 'package:flutter/material.dart';
import 'package:player/settings.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();

  String baseUrl = AppSettings().baseUrl;
  int screenId = AppSettings().screenId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back),
            tooltip: 'Back',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Form(
          key: _formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  initialValue: baseUrl,
                  decoration: const InputDecoration(
                    hintText: 'Server Address',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a valid server address.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    baseUrl = value;
                  },
                ),
                TextFormField(
                  initialValue: screenId.toString(),
                  decoration: const InputDecoration(
                    hintText: 'Screen ID',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a valid screen ID.';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Screen ID must be a number.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    screenId = int.parse(value);
                  },
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        final form = _formKey.currentState;
                        if (form.validate()) {
                          form.save();

                          print("Base: $baseUrl, ID: $screenId");
                          AppSettings settings = AppSettings();
                          settings.baseUrl = baseUrl;
                          settings.screenId = screenId;
                          Navigator.pop(context);
                        }
                      },
                      child: Text('Submit'),
                    )),
              ])),
    );
  }
}
