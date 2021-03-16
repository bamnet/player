final RegExp _iconRe = RegExp(r"<i class='owf owf-(\d+) owf-5x'><\/i>");
const iconZoom = '4x';

// swapIcon will replace the CSS which loads a weather icon with an img tag.
String swapIcon(String html) {
  // TODO: Support the `wi` format from
  //  https://github.com/concerto/concerto-weather/blob/master/app/models/weather.rb#L70
  if (_iconRe.hasMatch(html)) {
    var m = _iconRe.firstMatch(html);
    var id = int.parse(m[1]);

    var url = idToURL(id, iconZoom);
    html = html.replaceFirst(_iconRe, '<img src="$url" />');
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
  var code;
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
