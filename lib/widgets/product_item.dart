import 'package:flutter/material.dart';
import 'package:myshop/providers/product.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context, listen: false);

    return Consumer<Product>(
      builder: (context, product, child) => GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            onPressed: () {
              product.toggleFavStatus();
            },
            icon: Icon(
                product.isFavourite ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).colorScheme.secondary),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
              onPressed: () {
                cart.addItem(product.id, product.price, product.title);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Your Item added successfully"),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(label: "undo", onPressed: () {
                     cart.removeSingleItem(product.id);
                  }),
                ));
              },
              icon: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).colorScheme.secondary,
              )),
        ),
        child: Image.network(
          product.imageUrl,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
