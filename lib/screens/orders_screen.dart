import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop/providers/orders_controller.dart' hide OrderItem;
import 'package:shop/widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends ConsumerWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Your Orders',
            style: TextStyle(color: Colors.black87),
          ),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: ref.read(ordersProvider).fetchAndSetOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.error != null) {
                return Center(
                  child: Text('Some error'),
                );
              } else {
                return ListView.builder(
                    itemBuilder: (ctx, index) =>
                        OrderItem(ref.watch(ordersProvider).orders[index]),
                    itemCount: ref.watch(ordersProvider).orders.length);
              }
            }
          },
        ));
  }
}
