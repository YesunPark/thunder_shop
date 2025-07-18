import 'package:flutter/material.dart';

import 'package:thunder_shop/product_register/product_register_page.dart';
import 'package:thunder_shop/model/product.dart';
import '../cart/cart_page.dart';

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

  // 장바구니 상태
  List<CartItem> cartItems = [];

  // 상품 더미 데이터 생성
  Product _dummyProduct(int index) => Product(
    id: '$index',
    productName: '상품$index',
    descImageUrl: '',
    category: '카테고리',
    categoryDetail: '소분류',
    price: 30000,
    discountPrice: index == 0 ? 20000 : 30000,
    mainImageUrl: '',
    imageUrls: [],
    shippingInfo: '무료배송',
    shippingFee: 0,
  );

  // 장바구니에 상품 추가 로직
  void _addToCart(Product product) {
    setState(() {
      final idx = cartItems.indexWhere((item) => item.product.id == product.id);
      if (idx >= 0) {
        cartItems[idx].quantity++;
      } else {
        cartItems.add(CartItem(product: product));
      }
    });
  }

  void goToRegisterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProductRegisterPage()),
    );
  }

  // 장바구니 화면으로 이동 로직
  void goToCartPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CartPage(cartItems: cartItems)),
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
                IconButton(
                  onPressed: goToCartPage,
                  icon: const Icon(Icons.shopping_cart_outlined),
                ),
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
                        product: _dummyProduct(index),
                        onAddToCart: _addToCart,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: totalProducts,
                    itemBuilder: (context, index) => ProductItem(
                      product: _dummyProduct(index),
                      isRow: true,
                      onAddToCart: _addToCart,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
