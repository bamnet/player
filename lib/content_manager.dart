import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:player/content/content.dart';
import 'package:player/client/v2/client.dart' as api;

import 'content/converter.dart';

class NoContentException implements Exception {}

class ContentManager extends ChangeNotifier {
  final api.ConcertoV2Client client;
  final String fieldContentPath;
  final String fieldName;
  final String style;

  ConcertoContent _content;
  ListQueue<api.Content> queue = ListQueue();

  ContentManager(
      {this.client, this.fieldContentPath, this.style, this.fieldName});

  @override
  void dispose() {
    if (_content != null) {
      _content.dispose();
    }
    super.dispose();
  }

  Widget get content {
    if (_content != null) {
      // Trash the old content.
      // This is a hack to stop the timer from running.
      _content.dispose();
    }
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
    if (queue.length < 2) {
      refresh();
    }
  }

  void refresh() async {
    print('fetching $fieldContentPath');
    var items = await client.getContent(fieldContentPath: fieldContentPath);

    var queueWasEmpty = queue.isEmpty;

    queue.addAll(items);

    if (fieldName == 'Time' && queue.isEmpty) {
      var time = api.Content(duration: 60, type: 'Time');
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
