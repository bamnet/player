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
}
