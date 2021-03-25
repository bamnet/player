import 'package:fake_async/fake_async.dart';
import 'package:player/client/v2/client.dart';
import 'package:player/content_manager.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

class MockConcertoV2Client extends Mock implements ConcertoV2Client {}

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

  test('will not maybeRefresh too fast', () {
    fakeAsync((async) {
      final client = MockConcertoV2Client();
      when(client.getContent(fieldContentPath: 'path'))
          .thenAnswer((_) async => <Content>[]);

      final contentManager =
          ContentManager(client: client, fieldContentPath: 'path');
      contentManager.maybeRefresh();
      verify(client.getContent(fieldContentPath: 'path')).called(1);

      contentManager.maybeRefresh();
      verifyNever(client.getContent(fieldContentPath: 'path'));

      async.elapse(Duration(seconds: 5));

      contentManager.maybeRefresh();
      verify(client.getContent(fieldContentPath: 'path')).called(1);
    });
  });

  test('returns synthetic time field content', () {
    fakeAsync((async) {
      final client = MockConcertoV2Client();
      when(client.getContent(fieldContentPath: 'path'))
          .thenAnswer((_) async => <Content>[]);

      final contentManager = ContentManager(
          client: client, fieldContentPath: 'path', fieldName: 'Time');
      contentManager.refresh();
      async.elapse(Duration(seconds: 1));

      expect(contentManager.next.type, 'Time');
    });
  });

  group('notify listeners', () {
    test('once when first filled', () {
      fakeAsync((async) {
        final client = MockConcertoV2Client();
        when(client.getContent(fieldContentPath: 'path'))
            .thenAnswer((_) async => <Content>[
                  Content(id: 1),
                  Content(id: 2),
                  Content(id: 3),
                  Content(id: 4),
                ]);
        var notifyCount = 0;

        final contentManager =
            ContentManager(client: client, fieldContentPath: 'path');
        contentManager.addListener(() {
          notifyCount++;
        });
        contentManager.refresh();
        async.elapse(Duration(seconds: 1));

        expect(contentManager.queue.length, 4);
        expect(contentManager.next, isNotNull);
        expect(contentManager.queue.length, 3);
        expect(contentManager.next, isNotNull);

        expect(notifyCount, 1);
      });
    });

    test('when recovering from empty', () {
      fakeAsync((async) {
        final client = MockConcertoV2Client();

        var notifyCount = 0;

        final contentManager =
            ContentManager(client: client, fieldContentPath: 'path');
        contentManager.addListener(() {
          notifyCount++;
        });
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
        expect(notifyCount, 0);

        when(client.getContent(fieldContentPath: 'path'))
            .thenAnswer((_) async => <Content>[
                  Content(id: 3),
                  Content(id: 4),
                ]);

        // The queue is still empty, but the callback triggers.
        expect(() => contentManager.next, throwsException);
        async.elapse(Duration(seconds: 1));
        expect(notifyCount, 1);

        // The queue has content.
        expect(contentManager.next, isNotNull);
      });
    });
  });
}
