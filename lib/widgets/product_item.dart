import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/product.dart';

import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);

    final cart = Provider.of<Cart>(context, listen: false);

    final authData = Provider.of<Auth>(context, listen: false);

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
                      icon: Consumer<Product>(
                        builder: (ctx, product, _) => Icon(
                          product.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                        ),
                      ),
                      onPressed: () {
                        product.toogleFavoriteStatus(
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
