import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop/providers_riverpod/auth_controller.dart';
import 'package:shop/providers_riverpod/cart_controller.dart';
import 'package:shop/providers_riverpod/product_controller.dart';

import '../screens/product_detail_screen.dart';

class ProductItem extends ConsumerWidget {
  final Product product;

  ProductItem(this.product);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productController = ref.watch(productProvider(product));

    final cart = ref.watch(cartProvider);

    final authData = ref.watch(authProvider);

    return Container(
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                        ProductDetailScren.routeName,
                        arguments: product.id);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      height: double.infinity,
                      child: Hero(
                        tag: product.id,
                        child: FadeInImage(
                          placeholder: AssetImage(
                              'assets/images/product-placeholder.png'),
                          image: product.imageUrl != ""
                              ? NetworkImage(product.imageUrl)
                              : AssetImage(
                                  'assets/images/product-placeholder.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.white,
                    ),
                    child: IconButton(
                      icon: Icon(
                        product.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                      ),
                      onPressed: () {
                        productController.toogleFavoriteStatus(
                            authData.token, authData.userId);
                      },
                      color: !product.isFavorite
                          ? Colors.black87
                          : Theme.of(context).accentColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            width: double.infinity,
            child: Text(
              product.title,
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Text(
                "\$${product.price.toString()}",
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              IconButton(
                icon: Icon(CupertinoIcons.cart),
                onPressed: () {
                  cart.addItem(product.id, product.price, product.title,
                      product.imageUrl);

                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Added item to cart!'),
                    duration: Duration(milliseconds: 1200),
                    action: SnackBarAction(
                        label: "UNDO",
                        onPressed: () {
                          cart.removeSingleItem(product.id);
                        }),
                  ));
                },
                color: Theme.of(context).accentColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
