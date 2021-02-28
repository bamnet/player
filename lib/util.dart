import 'package:flutter/widgets.dart';
import 'package:hexcolor/hexcolor.dart';

RegExp _protocolRe = new RegExp(r'^[a-z0-9]+://');

/// Convert a path into an absolute URL if needed.
///
/// If the supplied [path] does not include a hostname
/// or protocol, the [baseURL] is prepended to turn it
/// into an absolute URL.
String absoluteURL(String baseURL, String path) {
  if (!_protocolRe.hasMatch(path)) {
    if (baseURL.endsWith('/')) {
      baseURL = baseURL.substring(0, baseURL.length - 1);
    }
    if (path.startsWith('/')) {
      path = path.substring(1, path.length);
    }
    return '$baseURL/$path';
  }
  return path;
}

TextStyle textStyle(String style) {
  RegExp styleRe = RegExp(r"(?<prop>[\w\-]+)\s?:\s?(?<val>[^;]+)");
  Iterable<RegExpMatch> matches = styleRe.allMatches(style);

  var parsed = {
    for (var match in matches)
      match.namedGroup('prop').toLowerCase(): match.namedGroup('val')
  };

  var t = TextStyle();
  if (parsed.containsKey('color')) {
    var hex = parsed['color'];
    if (hex.length == 4) {
      hex = "#${hex[1]}${hex[1]}${hex[2]}${hex[2]}${hex[3]}${hex[3]}";
    }
    t = t.merge(TextStyle(color: HexColor(hex)));
  }
  if (parsed.containsKey('font-weight')) {
    switch (parsed['font-weight']) {
      case 'bold':
        t = t.merge(TextStyle(fontWeight: FontWeight.bold));
        break;
    }
  }
  if (parsed.containsKey('font-family')) {
    var family = parsed['font-family'].split(new RegExp(r", ?"));
    t = t.merge(TextStyle(
        fontFamily: family.first, fontFamilyFallback: family.sublist(1)));
  }

  return t;
}
