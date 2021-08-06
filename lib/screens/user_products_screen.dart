import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop/providers_riverpod/productsController.dart';
import 'package:shop/widgets/user_product.dart';

import '../widgets/app_drawer.dart';
import './edit_product_screen.dart';

class UserProductsScreen extends ConsumerWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context, WidgetRef ref) async {
    await ref.read(productsProvider).fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('rebuilding...');
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Products',
          style: TextStyle(color: Colors.black87),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context, ref),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context, ref),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: ListView.builder(
                        itemCount: ref.watch(productsProvider).items.length,
                        itemBuilder: (_, i) => Column(
                          children: [
                            UserProduct(
                              ref.watch(productsProvider).items[i].title,
                              ref.watch(productsProvider).items[i].imageUrl,
                              ref.watch(productsProvider).items[i].id,
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
