import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shop/providers_riverpod/productsController.dart';

import './product_item.dart';

class ProductsGrid extends ConsumerStatefulWidget {
  const ProductsGrid();

  @override
  _ProductsGridState createState() => _ProductsGridState();
}

class _ProductsGridState extends ConsumerState<ProductsGrid> {
  bool _showOnlyFav = false;

  @override
  Widget build(BuildContext context) {
    final productsData = ref.watch(productsProvider);

    final products = _showOnlyFav ? productsData.favItems : productsData.items;

    return StaggeredGridView.countBuilder(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        padding: const EdgeInsets.all(16.0),
        itemCount: products.length + 2,
        staggeredTileBuilder: (index) {
          if (index == 0) return StaggeredTile.count(2, 0.4);
          if (index == 1) return StaggeredTile.count(2, 0.4);
          return StaggeredTile.count(1, index.isEven ? 1.7 : 1.2);
        },
        itemBuilder: (ctx, i) {
          if (i == 0)
            return Container(
                child: Text(
              "Find your \nnext purchase!",
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 28,
                  fontWeight: FontWeight.w500),
            ));
          if (i == 1)
            return Row(
              children: [
                ActionChip(
                  onPressed: () {
                    setState(() {
                      _showOnlyFav = !_showOnlyFav;
                    });
                  },
                  labelStyle: TextStyle(
                      color: _showOnlyFav ? Colors.white : Colors.black87),
                  label: Container(
                    height: 40,
                    width: 100,
                    child: Center(
                      child: Text(
                        'Only favorites',
                      ),
                    ),
                  ),
                  backgroundColor:
                      _showOnlyFav ? Colors.black87 : Colors.transparent,
                  side: BorderSide(
                    color: Colors.grey[300],
                  ),
                ),
              ],
            );
          return ProductItem(products[i - 2]);
        });
  }
}
