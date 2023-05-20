
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testowo/api/postDto.dart';

import 'catalog.dart';
import 'item_tile.dart';
class PostList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post list'),
      ),
      body: Selector<Catalog, int?>(
        selector: (context, catalog) => catalog.itemCount,
        builder: (context, itemCount, child) {
          if (itemCount == 0) {
            return const Center(
              child: Text('No entries found.'),
            );
          }

          return ListView.builder(
            itemCount: itemCount,
            padding: const EdgeInsets.symmetric(vertical: 18),
            itemBuilder: (context, index) {
              var catalog = Provider.of<Catalog>(context);

              var item = catalog.getByIndex(index);

              if (item.isLoading) {
                return const LoadingItemTile();
              } else {
                return ItemTile(item: item);
              }
            },
          );
        },
      ),
    );
  }
}