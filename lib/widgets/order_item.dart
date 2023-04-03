import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myshop/providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  const OrderItem({required this.order});

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(children: [
        ListTile(
          title: Text("\$ ${widget.order.amount}"),
          subtitle: Text(
              "${DateFormat("dd MM yyyy hh:mm").format(widget.order.dateTime)}"),
          trailing: IconButton(
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              icon: _expanded
                  ? Icon(Icons.expand_less)
                  : Icon(Icons.expand_more)),
        ),
        if (_expanded)
          Container(
            height: min(widget.order.products.length * 20 + 10, 150),
            child: ListView(
                children: widget.order.products.map((e) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${e.title}"),
                    Text("${e.quantity} * ${e.price}"),
                  ],
                )).toList()),
          )
      ]),
    );
  }
}
