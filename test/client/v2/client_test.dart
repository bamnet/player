import 'dart:io';

import 'package:player/client/v2/client.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockHTTPClient extends Mock implements http.Client {}

void main() {
  group('getScreen', () {
    test('returns a Screen on success', () async {
      final httpClient = MockHTTPClient();

      final file = File('test/testdata/setup_standard.json');
      when(httpClient.get(Uri.tryParse('http://server/frontend/1/setup.json')))
          .thenAnswer(
              (_) async => http.Response(await file.readAsString(), 200));

      final client =
          ConcertoV2Client(httpClient: httpClient, baseURL: 'http://server');

      final got = await client.getScreen(screenId: 1);
      expect(got, isA<Screen>());
      expect(got.name, 'Sample Screen');
      expect(got.template.path, '/frontend/1/templates/1.jpg');
      expect(got.template.positions.length, 4);

      final position = got.template.positions.first;
      expect(
          position.fieldContentsPath.startsWith('/frontend/1/fields/'), isTrue);
      expect(position.top, inExclusiveRange(0, 1));
      expect(position.left, inExclusiveRange(0, 1));
      expect(position.bottom, inExclusiveRange(0, 1));
      expect(position.right, inExclusiveRange(0, 1));
      expect(position.field.config['screens_clear_last_content'], isTrue);
    });
  });

  group('getContent', () {
    test('returns Contents on success', () async {
      final httpClient = MockHTTPClient();

      final file = File('test/testdata/content_multi.json');
      when(httpClient.get(
              Uri.tryParse('http://server/frontend/1/fields/1/contents.json')))
          .thenAnswer(
              (_) async => http.Response(await file.readAsString(), 200));

      final client =
          ConcertoV2Client(httpClient: httpClient, baseURL: 'http://server');

      final got = await client.getContent(
          fieldContentPath: '/frontend/1/fields/1/contents.json');
      expect(got, isA<List<Content>>());
      expect(got.length, 3);
      expect(got.first.name, 'Ticker Test');

      expect(got.map((e) => e.type), ['Ticker', 'Graphic', 'RemoteVideo']);

      expect(got.first.renderDetails['data'], contains('tick tick'));
      expect(got.last.renderDetails['path'], contains('embed/iframe'));
    });
  });
}
