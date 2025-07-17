import 'package:flutter/material.dart';
import 'package:thunder_shop/cart/cart_page.dart';
import 'package:thunder_shop/product_list/product_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'thunder_shop',
      initialRoute: '/',
      routes: {
        '/': (_) => const ProductListPage(),
        '/cart': (_) => const CartPage(),
      },
    );
  }
}
