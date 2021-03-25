import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:clock/clock.dart';
import 'package:player/content/content.dart';
import 'package:player/client/v2/client.dart' as api;

import 'content/converter.dart';

const minRefreshInterval = Duration(seconds: 1);
const minQueueSize = 2;

class NoContentException implements Exception {}

class ContentManager extends ChangeNotifier {
  final api.ConcertoV2Client client;
  final String fieldContentPath;
  final String fieldName;
  final String style;

  DateTime _lastRefreshAttempt = DateTime(0);
  ConcertoContent _content = EmptyContent();
  ListQueue<api.Content> queue = ListQueue();

  ContentManager(
      {@required this.client,
      @required this.fieldContentPath,
      this.style = '',
      this.fieldName = ''});

  @override
  void dispose() {
    _content.dispose();
    super.dispose();
  }

  Widget get content {
    // Trash the old content.
    // This is a hack to stop the timer from running.
    _content.dispose();
    try {
      var item = next;
      _content = convert(
          item: item,
          onFinish: notifyListeners,
          baseURL: client.baseURL,
          style: style);
      _content.play();
      return _content.widget;
    } on NoContentException {
      return SizedBox();
    }
  }

  api.Content get next {
    maybeRefresh();

    if (queue.isEmpty) {
      throw NoContentException();
    }

    return queue.removeFirst();
  }

  void maybeRefresh() {
    if (queue.length < minQueueSize &&
        clock.now().difference(_lastRefreshAttempt) > minRefreshInterval) {
      refresh();
    }
  }

  void refresh() async {
    _lastRefreshAttempt = clock.now();

    print('fetching $fieldContentPath');
    var items = await client.getContent(fieldContentPath: fieldContentPath);

    var queueWasEmpty = queue.isEmpty;

    queue.addAll(items);

    if (fieldName == 'Time' && queue.isEmpty) {
      var time = api.Content(id: 0, duration: 60, type: 'Time');
      // Add a bunch of time elements so we don't trigger
      // a refresh loop.
      queue.addAll([time, time, time]);
    }

    if (queueWasEmpty && queue.isNotEmpty) {
      // The queue was empty, but is no longer.
      // We should notify the app.
      notifyListeners();
    }
  }
}
