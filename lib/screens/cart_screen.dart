import 'package:flutter/material.dart';
import 'package:myshop/providers/orders.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart";

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("your cart"),
      ),
      body: Column(children: [
        Card(
          margin: EdgeInsets.all(15),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 22),
                  ),
                  Spacer(),
                  Chip(label: Text("${cart.totalAmount}")),
                  TextButton(onPressed: () {
                    Provider.of<Orders>(context,listen: false).addOrder(cart.items.values.toList(),cart.totalAmount );
                    cart.clear();
                  }, child: Text("ORDER NOW")),
                  SizedBox(
                    height: 10,
                  ),

                ]),
          ),
        ), Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return CartItem(
                    id: cart.items.values.toList()[index].id,
                    productId:  cart.items.keys.toList()[index],
                    title: cart.items.values.toList()[index].title,
                    quantity: cart.items.values.toList()[index].quantity,
                    price: cart.items.values.toList()[index].price);
              },
              itemCount: cart.items.length,
            ))
      ]),
    );
  }
}
