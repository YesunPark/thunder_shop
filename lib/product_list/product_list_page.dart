import 'package:flutter/material.dart';

import 'package:thunder_shop/product_register/product_register_page.dart';

import 'widgets/category_selector.dart';
import 'widgets/product_item.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  String selectedCategory = '식품';
  String selectedCategoryDetail = '전체'; // 변경됨
  bool isGridView = true;
  int totalProducts = 36; // 실제 상품 개수 받아오기

  void goToRegisterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProductRegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Stack(
          alignment: Alignment.center,
          children: [
            const Text('상품 목록'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: goToRegisterPage,
                  child: const Text(
                    '상품 등록',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const Icon(Icons.shopping_cart_outlined),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          CategorySelector(
            selectedCategory: selectedCategory,
            selectedCategoryDetail: selectedCategoryDetail,
            onCategorySelected: (category) {
              setState(() {
                selectedCategory = category;
                selectedCategoryDetail = '전체';
              });
            },
            onCategoryDetailSelected: (detail) {
              setState(() {
                selectedCategoryDetail = detail;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('총 $totalProducts개'),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => setState(() => isGridView = false),
                      icon: Icon(
                        Icons.view_list,
                        color: isGridView ? Colors.grey : Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => isGridView = true),
                      icon: Icon(
                        Icons.grid_view,
                        color: isGridView ? Colors.black : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: isGridView
                ? GridView.count(
                    padding: const EdgeInsets.all(12),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.65,
                    children: List.generate(
                      totalProducts,
                      (index) => ProductItem(
                        productName: '상품',
                        price: 30000,
                        discountPrice: index == 0 ? 20000 : null,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: totalProducts,
                    itemBuilder: (context, index) => ProductItem(
                      productName: '상품',
                      price: 30000,
                      discountPrice: index == 0 ? 20000 : null,
                      isRow: true,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
