import 'package:flutter/material.dart';
import 'cart/cart_page.dart';
import 'product_list/product_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 배너 숨김
      title: 'thunder_shop',
      initialRoute: '/',
      routes: {
        '/': (_) => const ProductListPage(),
        '/cart': (_) => const CartPage(cartItems: []),
      },
    );
  }
}
