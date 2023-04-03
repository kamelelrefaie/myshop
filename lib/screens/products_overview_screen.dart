import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:myshop/providers/cart.dart';
import 'package:myshop/screens/cart_screen.dart';
import 'package:myshop/widgets/app_drawer.dart';
import 'package:myshop/widgets/product_item.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';
import '../widgets/products_grid.dart';

class ProductOverViewScreen extends StatefulWidget {
  const ProductOverViewScreen({Key? key}) : super(key: key);

  @override
  State<ProductOverViewScreen> createState() => _ProductOverViewScreenState();
}

enum FilterOptions { fav, all }

class _ProductOverViewScreenState extends State<ProductOverViewScreen> {
  bool showFavs = false;
   var _isInit = true;
   var isLoaded = false;
  @override
  void didChangeDependencies() {
    if(_isInit) Provider.of<Products>(context).fetchAndSyncProducts();
    _isInit =false;
   setState(() {
     isLoaded = true;
   });
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(title: const Text("MyShop"), actions: [
        PopupMenuButton(
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: Text("only fav"),
                value: FilterOptions.fav,
              ),
              PopupMenuItem(
                child: Text("show all"),
                value: FilterOptions.all,
              )
            ];
          },
          icon: Icon(Icons.more_vert),
          onSelected: (FilterOptions value) {
            if (value == FilterOptions.fav) {
              setState(() {
                showFavs = true;
              });
            } else {
              setState(() {
                showFavs = false;
              });
            }
          },
        ),
        Consumer<Cart>(
            builder: (context, cart, ch) => Center(
              child: InkWell(onTap: (){Navigator.of(context).pushNamed(CartScreen.routeName);},
                child: Badge(
                      child: ch,
                      badgeContent: Text(cart.itemCount.toString()),
                    ),
              ),
            ),
            child: Icon(Icons.shopping_cart))
      ]),
      body: isLoaded?ProductsGrid(showFavs: showFavs): Center(child: CircularProgressIndicator(),),
    );
  }
}
