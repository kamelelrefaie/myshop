import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const ProductItem(
      {required this.id, required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return GridTile(
      footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            onPressed: () {},
            icon:  Icon(Icons.favorite,color: Theme.of(context).colorScheme.secondary),
          ),
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),trailing: IconButton(onPressed: (){},icon:  Icon(Icons.shopping_cart,color: Theme.of(context).colorScheme.secondary,)),),
      child: Image.network(
        imageUrl,
        fit: BoxFit.fill,
      ),
    );
  }
}
