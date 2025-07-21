import 'package:flutter/material.dart';
import '../model/product.dart';
import 'widgets/product_image_slider.dart';
import 'widgets/product_price_info.dart';
import 'widgets/purchase_bottom_sheet.dart';
import 'package:thunder_shop/model/favorite_button.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _currentIndex = 0;

  List<String> get imageList {
    return widget.product.imageUrls.isNotEmpty
        ? widget.product.imageUrls
        : ['https://picsum.photos/seed/${widget.product.id}/300/250'];
  }

  void toggleFavorite() {
    setState(() {
      widget.product.isLiked = !widget.product.isLiked; // ✅ 찜 상태 토글
    });
  }

  void showPurchaseSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => PurchaseBottomSheet(
        productName: widget.product.productName,
        originalPrice: widget.product.price,
        salePrice: widget.product.discountPrice,
        imageUrl: imageList[0],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: const Text('상품 상세'),
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

          Text(
            product.productName,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          ProductPriceInfo(
            originalPrice: product.price,
            salePrice: product.discountPrice,
          ),
          const SizedBox(height: 24),

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.shippingInfo),
                  const SizedBox(height: 8),
                  Text('${product.shippingFee}원'),
                ],
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
              FavoriteButton(
                isFavorite: widget.product.isLiked,
                onToggle: toggleFavorite,
                size: 30,
                activeColor: Colors.pink,
                inactiveColor: Colors.black,
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
