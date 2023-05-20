// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:testowo/api/postDto.dart';

import 'itemDetailsPage.dart';


/// This is the widget responsible for building the item in the list,
/// once we have the actual data [item].
class ItemTile extends StatelessWidget {
  final PostDTO item;

  const ItemTile({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsPage(item: item),
              fullscreenDialog: true,
            ),
          );
        },
        leading: AspectRatio(
          aspectRatio: 1,
          child: Center(
            child: Text(item.id.toString(), style: Theme.of(context).textTheme.titleLarge),
          ),
        ),
        title: Text(item.title, style: Theme.of(context).textTheme.titleMedium),
        trailing: Text(''),
      ),
    );
  }
}


/// This is the widget responsible for building the "still loading" item
/// in the list (represented with "..." and a crossed square).
class LoadingItemTile extends StatelessWidget {
  const LoadingItemTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: const AspectRatio(
          aspectRatio: 1,
          child: Text(''),
        ),
        title: Text('Loading...', style: Theme.of(context).textTheme.titleLarge),
        trailing: const Text(''),
      ),
    );
  }
}
