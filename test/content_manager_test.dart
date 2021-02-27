import 'package:fake_async/fake_async.dart';
import 'package:player/client/v2/client.dart';
import 'package:player/content_manager.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

class MockConcertoV2Client extends Mock implements ConcertoV2Client {}

class FakeField {
  void callback() {}
}

class MockField extends Mock implements FakeField {}

void main() {
  test('fetches next content', () {
    fakeAsync((async) {
      final client = MockConcertoV2Client();
      when(client.getContent(fieldContentPath: 'path'))
          .thenAnswer((_) async => <Content>[
                Content(id: 1, name: 'First'),
                Content(id: 2, name: 'Second'),
                Content(id: 3, name: 'Third'),
              ]);

      final contentManager =
          ContentManager(client: client, fieldContentPath: 'path');
      contentManager.refresh();

      async.elapse(Duration(seconds: 1));

      expect(contentManager.next.id, 1);
      expect(contentManager.next.name, 'Second');
    });
  });

  test('continually fetches content', () {
    fakeAsync((async) {
      final client = MockConcertoV2Client();
      when(client.getContent(fieldContentPath: 'path'))
          .thenAnswer((_) async => <Content>[
                Content(id: 1, name: 'First'),
                Content(id: 2, name: 'Second'),
              ]);

      final contentManager =
          ContentManager(client: client, fieldContentPath: 'path');
      contentManager.refresh();

      async.elapse(Duration(seconds: 1));
      expect(contentManager.next.id, 1);

      async.elapse(Duration(seconds: 1));
      expect(contentManager.next.id, 2);

      async.elapse(Duration(seconds: 1));
      expect(contentManager.next.id, 1);

      async.elapse(Duration(seconds: 1));
      expect(contentManager.next.id, 2);

      async.elapse(Duration(seconds: 1));
      expect(contentManager.next.id, 1);

      async.elapse(Duration(seconds: 1));
      expect(contentManager.next.id, 2);
    });
  });

  group('onFinish callback', () {
    test('invokes callback once when first filled', () {
      fakeAsync((async) {
        final client = MockConcertoV2Client();
        when(client.getContent(fieldContentPath: 'path'))
            .thenAnswer((_) async => <Content>[
                  Content(id: 1),
                  Content(id: 2),
                  Content(id: 3),
                  Content(id: 4),
                ]);

        final field = MockField();

        final contentManager = ContentManager(
            client: client, fieldContentPath: 'path', onRefill: field.callback);
        contentManager.refresh();
        async.elapse(Duration(seconds: 1));

        expect(contentManager.queue.length, 4);
        expect(contentManager.next, isNotNull);
        expect(contentManager.queue.length, 3);
        expect(contentManager.next, isNotNull);

        verify(field.callback()).called(1);
      });
    });

    test('invokes callback when recovering from empty', () {
      fakeAsync((async) {
        final client = MockConcertoV2Client();
        final field = MockField();

        final contentManager = ContentManager(
            client: client, fieldContentPath: 'path', onRefill: field.callback);
        contentManager.queue.addAll(<Content>[
          Content(id: 1),
          Content(id: 2),
        ]);

        when(client.getContent(fieldContentPath: 'path'))
            .thenAnswer((_) async => <Content>[]);

        // Drain the queue.
        expect(contentManager.next, isNotNull);
        async.elapse(Duration(seconds: 1));
        expect(contentManager.next, isNotNull);
        async.elapse(Duration(seconds: 1));

        // The queue is now empty. Next time it refills, it should callback.
        expect(() => contentManager.next, throwsException);
        async.elapse(Duration(seconds: 1));
        verifyNever(field.callback());

        when(client.getContent(fieldContentPath: 'path'))
            .thenAnswer((_) async => <Content>[
                  Content(id: 3),
                  Content(id: 4),
                ]);

        // The queue is still empty, but the callback triggers.
        expect(() => contentManager.next, throwsException);
        async.elapse(Duration(seconds: 1));
        verify(field.callback()).called(1);

        // The queue has content.
        expect(contentManager.next, isNotNull);
      });
    });
  });
}
