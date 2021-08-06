import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop/providers_riverpod/cart_controller.dart' hide CartItem;
import 'package:shop/providers_riverpod/orders_controller.dart';
import '../widgets/cart_item.dart' show CartItem;

class CartScreen extends ConsumerWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartData = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Cart',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: Column(
        children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 2,
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 18),
                  ),
                  Spacer(),
                  Chip(
                      label: Text(
                        '\$${cartData.totalAmount}',
                        style: TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .headline6
                                .color),
                      ),
                      backgroundColor: Colors.black87),
                  OrderNowButton()
                ],
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Expanded(
              child: ListView.builder(
            itemCount: cartData.itemCount,
            itemBuilder: (ctx, index) {
              return CartItem(
                  cartData.items.values.toList()[index].id,
                  cartData.items.values.toList()[index].price,
                  cartData.items.values.toList()[index].quantity,
                  cartData.items.values.toList()[index].title,
                  cartData.items.keys.toList()[index],
                  cartData.items.values.toList()[index].imageUrl);
            },
          ))
        ],
      ),
    );
  }
}

class OrderNowButton extends ConsumerStatefulWidget {
  const OrderNowButton({
    Key key,
  }) : super(key: key);

  @override
  _OrderNowButtonState createState() => _OrderNowButtonState();
}

class _OrderNowButtonState extends ConsumerState<OrderNowButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cartData = ref.watch(cartProvider);

    return TextButton(
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              'Order now',
            ),
      onPressed: (cartData.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              ref.watch(ordersProvider).addOrder(
                  cartData.items.values.toList(), cartData.totalAmount);
              cartData.clear();
              setState(() {
                _isLoading = false;
              });
            },
    );
  }
}
