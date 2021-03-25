import 'package:flutter/widgets.dart';
import 'package:hexcolor/hexcolor.dart';

final RegExp _protocolRe = RegExp(r'^[a-z0-9]+://');
final RegExp _styleRe = RegExp(r'(?<prop>[\w\-]+)\s?:\s?(?<val>[^;]+)');
final RegExp _splitRe = RegExp(r', ?');

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

/// Parse a simple css style string into a Map.
Map<String, String?> cssMap(String style) {
  var matches = _styleRe.allMatches(style);

  return {
    for (var match in matches)
      match.namedGroup('prop')!.toLowerCase(): match.namedGroup('val')
  };
}

BoxDecoration? cssToBoxDecoration(String style) {
  var parsed = cssMap(style);
  if (parsed.containsKey('border')) {
    var pieces = parsed['border']!.split(' ');
    var width = double.parse(pieces[1].replaceAll('px', ''));
    var b = Border.all(
      width: width,
      color: cssColor(pieces[2]),
    );

    return BoxDecoration(border: b);
  }
  return null;
}

TextStyle cssToTextStyle(String style) {
  var parsed = cssMap(style);
  var t = TextStyle();

  if (parsed.containsKey('color')) {
    var hex = parsed['color']!;
    t = t.merge(TextStyle(color: cssColor(hex)));
  }
  if (parsed.containsKey('font-weight')) {
    switch (parsed['font-weight']) {
      case 'bold':
        t = t.merge(TextStyle(fontWeight: FontWeight.bold));
        break;
    }
  }
  if (parsed.containsKey('font-family')) {
    var family = parsed['font-family']!.split(_splitRe);
    t = t.merge(TextStyle(
        fontFamily: family.first, fontFamilyFallback: family.sublist(1)));
  }

  return t;
}

/// Convert a css color string into a [Color] object.
///
/// The heavy lifting here is done by the [HexColor] library,
/// but additional logic is used to handle various CSS formats.
Color cssColor(String hex) {
  if (hex.length == 4) {
    hex = '#${hex[1]}${hex[1]}${hex[2]}${hex[2]}${hex[3]}${hex[3]}';
  }
  return HexColor(hex);
}
