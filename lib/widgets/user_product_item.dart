import 'package:flutter/material.dart';
import 'package:myshop/providers/products.dart';
import 'package:myshop/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  
  const UserProductItem(
      {super.key, required this.title, required this.imageUrl, required this.id});



  @override
  Widget build(BuildContext context) {

    return ListTile(
      title: Text(title),
      leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
      trailing: Container(
        width: 100,
        child: Row(children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName,arguments: id);
            },
            icon: Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
            Provider.of<Products>(context).removeProduct(id);
            },
            icon: Icon(Icons.delete),
            color: Colors.red,
          )
        ]),
      ),
    );
  }
}
