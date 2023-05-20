// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:testowo/api/postDto.dart';

import 'api/fetch.dart';
import 'api/page.dart';

/// The [Catalog] holds items in memory, provides a synchronous access
/// to them via [getByIndex], and notifies listeners when there is any change.
class Catalog extends ChangeNotifier {
  static const maxCacheDistance = 100;

  final Map<int, ItemPage> _pages = {};
  final Set<int> _pagesBeingFetched = {};
  int? itemCount;
  int pageSize = 15;
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  PostDTO getByIndex(int index) {
    var startingIndex = (index ~/ pageSize) * pageSize;

    if (!_pages.containsKey(startingIndex)) {
      _fetchPage(startingIndex);

      return PostDTO.loading();
    }

    var page = _pages[startingIndex]!;
    if (index >= startingIndex + page.items.length) {
      // The index is out of range, return a placeholder or handle the error as desired.
      return PostDTO.empty();
    }

    var item = page.items[index - startingIndex];
    return item;
  }

  /// This method initiates fetching of the [ItemPage] at [startingIndex].
  Future<void> _fetchPage(int startingIndex) async {
    if (_pagesBeingFetched.contains(startingIndex)) {
      return;
    }

    _pagesBeingFetched.add(startingIndex);
    final page = await fetchPage(startingIndex, pageSize);
    _pagesBeingFetched.remove(startingIndex);

    if (!page.hasNext) {
      // The returned page has no next page. This means we now know the size
      // of the catalog.
      itemCount = startingIndex + page.items.length;
    }

    // Store the new page.
    _pages[startingIndex] = page;
    _pruneCache(startingIndex);

    if (!_isDisposed) {
      // Notify the widgets that are listening to the catalog that they
      // should rebuild.
      notifyListeners();
    }
  }

  /// Removes item pages that are too far away from [currentStartingIndex].
  void _pruneCache(int currentStartingIndex) {
    // It's bad practice to modify collections while iterating over them.
    // So instead, we'll store the keys to remove in a separate Set.
    final keysToRemove = <int>{};
    for (final key in _pages.keys) {
      if ((key - currentStartingIndex).abs() > maxCacheDistance) {
        // This page's starting index is too far away from the current one.
        // We'll remove it.
        keysToRemove.add(key);
      }
    }
    for (final key in keysToRemove) {
      _pages.remove(key);
    }
  }
}
