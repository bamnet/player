import 'package:player/content/weather.dart';
import 'package:test/test.dart';
import 'package:player/client/v2/client.dart' as api;

void main() {
  test('upgrade', () {
    expect(upgrade(api.Content(id: 0, name: 'Not Weather'), () {}), isNull);

    var troy = upgrade(
        api.Content(
          id: 0,
          name: 'Current weather in Troy',
          duration: 0,
          renderDetails: {
            'data':
                "<h1> Today in Secaucus </h1>\n<div style='float: left; width: 50%'>\n  <i class='owf owf-701 owf-5x'></i>\n</div>\n<div style='float: left; width: 50%'>\n  <p> Current </p>\n  <h1> 47 &deg;F </h1>\n</div>"
          },
        ),
        () {})!;
    expect(troy, isA<ConcertoWeather>());
    expect(troy.location, 'Troy');
    expect(troy.weatherID, 701);
    expect(troy.temperature, 47);
    expect(troy.units, 'F');

    var nyc = upgrade(
        api.Content(
          id: 0,
          name: 'Current weather in New York',
          duration: 0,
          renderDetails: {
            'data':
                "\n<h1> Today in New York </h1>\n<div style='float: left; width: 50%'>\n  <i style='font-size:calc(min(80vh,80vw));' class='wi wi-owm-804'></i>\n</div>\n<div style='float: left; width: 50%'>\n  <p> Current </p>\n  <h1> 2 &deg;C </h1>\n</div>\n"
          },
        ),
        () {})!;
    expect(nyc, isA<ConcertoWeather>());
    expect(nyc.location, 'New York');
    expect(nyc.weatherID, 804);
    expect(nyc.temperature, 2);
    expect(nyc.units, 'C');
  });
  test('swap weather icon', () {
    expect(swapIcon('<i>Non-weather</i>'), '<i>Non-weather</i>');
    expect(swapIcon("<i class='owf owf-701 owf-5x'></i>"),
        '<img src="https://openweathermap.org/img/wn/50d@4x.png" />');
    expect(swapIcon("The weather is: <i class='owf owf-602 owf-5x'></i>"),
        'The weather is: <img src="https://openweathermap.org/img/wn/13d@4x.png" />');
    expect(
        swapIcon(
            "<i style='font-size:calc(min(80vh,80vw));' class='wi wi-owm-804'></i>"),
        '<img src="https://openweathermap.org/img/wn/04d@4x.png" />');
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
