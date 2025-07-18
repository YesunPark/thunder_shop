import 'package:flutter/material.dart';
import 'widgets/product_image_slider.dart';
import 'widgets/product_price_info.dart';
import 'widgets/purchase_bottom_sheet.dart';

class ProductDetailPage extends StatefulWidget {
  final bool showBottomBar;

  const ProductDetailPage({super.key, this.showBottomBar = false});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _currentIndex = 0;

  final List<String> imageList = [
    'https://picsum.photos/seed/1/300/250',
    'https://picsum.photos/seed/2/300/250',
    'https://picsum.photos/seed/3/300/250',
    'https://picsum.photos/seed/4/300/250',
  ];

  final String productName = '부드러운 닭가슴살 12팩';
  final int originalPrice = 58000;
  final int salePrice = 25000;

  void showPurchaseSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => PurchaseBottomSheet(
        productName: productName,
        originalPrice: originalPrice,
        salePrice: salePrice,
        imageUrl: imageList[0],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('홈페이지 제목'),
        centerTitle: true,
        leading: const BackButton(),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ProductImageSlider(
            imageList: imageList,
            currentIndex: _currentIndex,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
          ),
          const SizedBox(height: 16),

          // 상품 제목 및 가격
          Text(
            productName,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          ProductPriceInfo(originalPrice: originalPrice, salePrice: salePrice),
          const SizedBox(height: 24),

          // 배송 정보
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('배송정보', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('배송비', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(width: 40),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text('번개 택배'), SizedBox(height: 8), Text('3,000원')],
              ),
            ],
          ),
          const SizedBox(height: 24),

          const Text('상품 세부정보', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            height: 150,
            width: double.infinity,
            color: Colors.grey[200],
            alignment: Alignment.center,
            child: const Text('이미지'),
          ),
          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('상품 후기', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('총 2개'),
            ],
          ),
          const SizedBox(height: 12),
          const Text('이름1', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('맛이 부드럽고 양도 넉넉해요'),
          const SizedBox(height: 12),
          const Text('이름2', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('배송도 빠르고 만족해요'),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {},
            child: const Text('상품 문의 >', style: TextStyle(color: Colors.blue)),
          ),
          const SizedBox(height: 80),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.add_shopping_cart_outlined),
                onPressed: () => showPurchaseSheet(context),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => showPurchaseSheet(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text('구매하기', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
