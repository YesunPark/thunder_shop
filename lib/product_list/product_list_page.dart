import 'package:flutter/material.dart';
import 'package:thunder_shop/product_register/product_register_page.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({Key? key}) : super(key: key);

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('상품 목록')),
      body: const Center(child: Text('상품 목록이 여기에 표시됩니다.')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProductRegisterPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
        tooltip: '상품 등록',
      ),
    );
  }
}
