import 'package:flutter/material.dart';
import 'package:myshop/widgets/product_item.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';
import '../screens/product_detail_screen.dart';

class ProductsGrid extends StatelessWidget {
  bool showFavs;
  ProductsGrid({required this.showFavs});
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFavs? productsData.favouritesItem : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 3 / 2),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: products[index].id);
          },
          child: ChangeNotifierProvider.value(
            value: products[index],
            child: ProductItem(),
          ),
        );
      },
      itemCount: products.length,
    );
  }
}
