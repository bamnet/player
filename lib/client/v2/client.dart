import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:player/util.dart';

class ConcertoV2Client {
  final String baseURL;
  http.Client httpClient;

  ConcertoV2Client({this.httpClient, this.baseURL});

  Future<Screen> getScreen({int screenId}) async {
    var setupURL = absoluteURL(this.baseURL, '/frontend/$screenId/setup.json');
    final response = await httpClient.get(Uri.tryParse(setupURL));
    final parsed = jsonDecode(response.body).cast<String, dynamic>();
    return Screen.fromJson(parsed);
  }

  Future<List<Content>> getContent({String fieldContentPath}) async {
    var contentURL = absoluteURL(this.baseURL, fieldContentPath);
    final response = await httpClient.get(Uri.tryParse(contentURL));
    final parsed = jsonDecode(response.body) as List<dynamic>;
    return parsed.map((c) => Content.fromJson(c)).toList();
  }
}

class Screen {
  int id;
  String name;
  String timeZone;
  String locale;
  Template template;

  Screen.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        timeZone = json['time_zone'],
        locale = json['locale'],
        template = Template.fromJson(json['template']);
}

class Template {
  int id;
  String name;
  String path;
  String cssPath;

  Set<Position> positions;

  Template.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        path = json['path'],
        cssPath = json['css_path'],
        positions = (json['positions'] as List<dynamic>)
            .map((e) => Position.fromJson(e))
            .toSet();
}

class Position {
  int id;
  String style;
  double top;
  double left;
  double bottom;
  double right;
  String fieldContentsPath;

  Field field;

  Position.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        style = json['style'],
        top = double.parse(json['top']),
        left = double.parse(json['left']),
        bottom = double.parse(json['bottom']),
        right = double.parse(json['right']),
        fieldContentsPath = json['field_contents_path'],
        field = Field.fromJson(json['field']);
}

class Field {
  int id;
  String name;
  Map<String, dynamic> config;

  Field.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        config = json['config'];
}

class Content {
  int id;
  String name;
  int duration;
  String type;
  Map<String, dynamic> renderDetails;

  Content({this.id, this.name, this.duration, this.type, this.renderDetails});

  Content.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        duration = json['duration'],
        type = json['type'],
        renderDetails = json['render_details'];
}
