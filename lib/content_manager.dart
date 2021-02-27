import 'dart:collection';

import 'package:flutter/painting.dart';
import 'package:player/client/v2/client.dart' as api;

class NoContentException implements Exception {}

class ContentManager {
  final api.ConcertoV2Client client;
  final String fieldContentPath;
  final String fieldName;
  final VoidCallback onRefill;

  ListQueue<api.Content> queue = ListQueue();

  ContentManager(
      {this.client, this.fieldContentPath, this.fieldName, this.onRefill});

  api.Content get next {
    _maybeRefresh();

    if (queue.isEmpty) {
      throw NoContentException();
    }

    return queue.removeFirst();
  }

  void _maybeRefresh() {
    if (queue.length < 2) {
      refresh();
    }
  }

  void refresh() async {
    print("fetching $fieldContentPath");
    List<api.Content> items =
        await client.getContent(fieldContentPath: fieldContentPath);

    bool queueWasEmpty = queue.isEmpty;

    queue.addAll(items);

    if (fieldName == 'Time' && queue.isEmpty) {
      queue.add(api.Content(duration: 60, type: 'Time'));
    }

    if (queueWasEmpty && queue.isNotEmpty && onRefill != null) {
      // The queue was empty, but is no longer.
      // We should notify the app.
      onRefill();
    }
  }
}
