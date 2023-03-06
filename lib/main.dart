import 'package:flutter/material.dart';
import 'package:myshop/providers/products.dart';
import 'package:myshop/screens/products_overview_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) { return Products(); },
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: "Lato",
          primarySwatch: Colors.purple,
          colorScheme: ColorScheme.fromSwatch().copyWith( secondary: Colors.deepOrange)
        ),
        home: ProductOverViewScreen()
      ),
    );
  }
}


