import 'package:flutter/material.dart';
import 'package:myshop/providers/orders.dart' show Orders;
import 'package:myshop/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {

  static const routeName = "/orders";
  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    return Scaffold(appBar: AppBar(title: Text("Your Orders")),
      body: ListView.builder(
          itemBuilder:(context, index) {
            return OrderItem(order: ordersData.orders[index]);
          }, itemCount: ordersData.orders.length),drawer: AppDrawer(),);
  }
}
