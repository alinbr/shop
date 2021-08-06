import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop/providers/products_controller.dart';
import 'package:shop/screens/edit_product_screen.dart';

class UserProduct extends ConsumerWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProduct(this.title, this.imageUrl, this.id);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffold = Scaffold.of(context);

    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        radius: 32,
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              color: Colors.amber,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  ref.watch(productsProvider).deleteProduct(id);
                } catch (error) {
                  scaffold
                      .showSnackBar(SnackBar(content: Text('Deleting failed')));
                }
              },
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
