import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:player/content/content.dart';
import 'package:player/client/v2/client.dart' as api;

final RegExp _owfIconRe = RegExp(r"<i class='owf owf-(\d+) owf-5x'><\/i>");
final RegExp _wiIconRe = RegExp(
    r"<i style='font-size:calc\(min\(80vh,80vw\)\);' class='wi wi-owm-(\d+)'><\/i>");
final RegExp _tempRe = RegExp(r'(?<temp>\d+) &deg;(?<units>\w)');
const iconZoom = '4x';

class ConcertoWeather extends ConcertoContent {
  final String location;
  final int weatherID;
  final double temperature;
  final String? units;

  ConcertoWeather(
      {required Duration duration,
      required VoidCallback onFinish,
      required int id,
      required this.location,
      required this.weatherID,
      required this.temperature,
      required this.units})
      : super(duration: duration, onFinish: onFinish, id: id);

  @override
  ConcertoWeatherWidget get widget {
    return ConcertoWeatherWidget(
        key: ValueKey(id),
        location: location,
        weatherID: weatherID,
        temperature: temperature,
        units: units);
  }
}

class ConcertoWeatherWidget extends StatefulWidget {
  final String location;
  final int weatherID;
  final double temperature;
  final String? units;

  ConcertoWeatherWidget(
      {Key? key,
      required this.location,
      required this.weatherID,
      required this.temperature,
      required this.units})
      : super(key: key);

  @override
  _ConcertoWeatherWidgetState createState() => _ConcertoWeatherWidgetState();
}

class _ConcertoWeatherWidgetState extends State<ConcertoWeatherWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: Fix this layout so it works on small screens too.
    return Column(
      children: [
        Text('Today in ${widget.location}',
            style:
                DefaultTextStyle.of(context).style.apply(fontSizeFactor: 4.0)),
        Row(children: [
          Expanded(
              child: Image.network(idToURL(widget.weatherID, iconZoom),
                  fit: BoxFit.contain)),
          Column(children: [
            Text('Current',
                style: DefaultTextStyle.of(context)
                    .style
                    .apply(fontSizeFactor: 2.0)),
            Text('${widget.temperature}° ${widget.units}',
                style: DefaultTextStyle.of(context)
                    .style
                    .apply(fontSizeFactor: 5.0, fontWeightDelta: 2))
          ])
        ])
      ],
    );
  }
}

int _weatherID(String html) {
  var wID = _owfIconRe.firstMatch(html);
  wID ??= _wiIconRe.firstMatch(html);
  if (wID == null) {
    return 0;
  }
  return int.parse(wID[1]!);
}

ConcertoWeather? upgrade(api.Content item, VoidCallback onFinish) {
  const prefix = 'Current weather in ';
  if (item.name.startsWith(prefix)) {
    var location = item.name.substring(prefix.length);

    var matches = _tempRe.firstMatch(item.renderDetails['data'])!;
    var temp = double.parse(matches.namedGroup('temp')!);
    var unit = matches.namedGroup('units');

    var weatherID = _weatherID(item.renderDetails['data']);

    return ConcertoWeather(
      location: location,
      weatherID: weatherID,
      temperature: temp,
      units: unit,
      duration: Duration(seconds: item.duration),
      onFinish: onFinish,
      id: item.id,
    );
  }
  return null;
}

// swapIcon will replace the CSS which loads a weather icon with an img tag.
String swapIcon(String html) {
  if (_owfIconRe.hasMatch(html)) {
    var m = _owfIconRe.firstMatch(html)!;
    var id = int.parse(m[1]!);

    var url = idToURL(id, iconZoom);
    html = html.replaceFirst(_owfIconRe, '<img src="$url" />');
  }
  if (_wiIconRe.hasMatch(html)) {
    var m = _wiIconRe.firstMatch(html)!;
    var id = int.parse(m[1]!);

    var url = idToURL(id, iconZoom);
    html = html.replaceFirst(_wiIconRe, '<img src="$url" />');
  }
  return html;
}

// idToURL converts an Open Weather ID into a URL for the icon.
String idToURL(int id, [String scale = '']) {
  if (scale.isNotEmpty) {
    scale = '@' + scale;
  }
  return 'https://openweathermap.org/img/wn/${_idToIcon(id)}$scale.png';
}

// _idToIcon takes an Open Weather ID and converts it into an icon ID.
String _idToIcon(int id) {
  var code = '03d'; // Default to clouds.
  if (id >= 200) {
    code = '11d';
  }
  if (id >= 300) {
    code = '09d';
  }
  if (id >= 500) {
    code = '10d';
  }
  if (id == 511) {
    code = '13d';
  }
  if (id >= 520) {
    code = '09d';
  }
  if (id >= 600) {
    code = '13d';
  }
  if (id >= 701) {
    code = '50d';
  }
  if (id == 800) {
    code = '01d';
  }
  if (id == 801) {
    code = '02d';
  }
  if (id == 802) {
    code = '03d';
  }
  if (id >= 803) {
    code = '04d';
  }
  return code;
}
