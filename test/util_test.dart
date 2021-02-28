import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:player/util.dart';
import 'package:test/test.dart';

void main() {
  test('absoluteURL works correctly', () {
    expect(absoluteURL('unused', 'https://absolute/path.jpg'),
        'https://absolute/path.jpg');
    expect(absoluteURL('unused', 'file:///path.jpg'), 'file:///path.jpg');

    expect(absoluteURL('https://server/root', 'path.jpg'),
        'https://server/root/path.jpg');

    expect(absoluteURL('https://server/root/', 'path.jpg'),
        'https://server/root/path.jpg');

    expect(absoluteURL('https://server/root', '/path.jpg'),
        'https://server/root/path.jpg');

    expect(absoluteURL('https://server/root/', '/path.jpg'),
        'https://server/root/path.jpg');

    expect(absoluteURL('https://server/root/', ':/path.jpg'),
        'https://server/root/:/path.jpg');
  });

  test('cssColor', () {
    expect(cssColor('#fff').value, Colors.white.value);
    expect(cssColor('#000000').value, Colors.black.value);
  });

  test('cssToTextStyle', () {
    var style =
        'color:#FFF; font-family: Frobisher, Arial, sans-serif; font-weight:bold; ';
    expect(
        cssToTextStyle(style),
        TextStyle(
          color: HexColor('#ffffff'),
          fontWeight: FontWeight.bold,
          fontFamily: 'Frobisher',
          fontFamilyFallback: ['Arial', 'sans-serif'],
        ));
  });

  test('cssToBoxDecoration', () {
    var style = 'border: solid 2px #fff;';
    expect(
        cssToBoxDecoration(style),
        BoxDecoration(
            border: Border.all(color: HexColor('#ffffff'), width: 2)));
  });
}
