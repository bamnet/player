import 'package:player/content/weather.dart';
import 'package:test/test.dart';

void main() {
  test('swap weather icon', () {
    expect(swapIcon('<i>Non-weather</i>'), '<i>Non-weather</i>');
    expect(swapIcon("<i class='owf owf-701 owf-5x'></i>"),
        '<img src="https://openweathermap.org/img/wn/50d@4x.png" />');
    expect(swapIcon("The weather is: <i class='owf owf-602 owf-5x'></i>"),
        'The weather is: <img src="https://openweathermap.org/img/wn/13d@4x.png" />');
  });
  test('idToURL works correctly', () {
    // These are manually grabbed from
    // https://openweathermap.org/weather-conditions.
    var tests = {
      200: '11d',
      310: '09d',
      501: '10d',
      511: '13d',
      521: '09d',
      601: '13d',
      701: '50d',
      800: '01d',
      804: '04d',
    };
    tests.forEach((key, value) {
      expect(idToURL(key), contains('img/wn/$value.png'));
    });

    expect(idToURL(200, '2x'), contains('11d@2x.png'));
    expect(idToURL(800, '4x'), contains('01d@4x.png'));
  });
}
