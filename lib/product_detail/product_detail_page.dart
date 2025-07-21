import 'package:flutter/material.dart';
import 'package:thunder_shop/model/cart_item.dart';
import '../model/product.dart';
import 'widgets/product_image_slider.dart';
import 'widgets/product_price_info.dart';
import 'widgets/purchase_bottom_sheet.dart';
import 'widgets/product_review.dart'; // ✅ 수정된 리뷰 표시용 위젯
import 'package:thunder_shop/model/favorite_button.dart';
import 'package:thunder_shop/style/common_colors.dart';
import 'package:thunder_shop/cart/cart_page.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  final List<CartItem> cartItems;
  final void Function(Product) onAddToCart;

  const ProductDetailPage({
    super.key,
    required this.product,
    required this.cartItems,
    required this.onAddToCart,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _currentIndex = 0;
  int _reviewCount = 0; // ✅ 리뷰 개수 상태
  bool _showInquiryForm = false;

  List<String> get imageList {
    return widget.product.imageUrls.isNotEmpty
        ? widget.product.imageUrls
        : ['https://picsum.photos/seed/${widget.product.id}/300/250'];
  }

  void toggleFavorite() {
    setState(() {
      widget.product.isLiked = !widget.product.isLiked;
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

  // 장바구니 담기 로직
  void _addToCart(BuildContext context) {
    widget.onAddToCart(widget.product);
  }

  void _updateReviewCount(int count) {
    setState(() {
      _reviewCount = count;
    });
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CartPage(cartItems: widget.cartItems),
                ),
              );
            },
            // 장바구니 아이콘
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

          // 🔽 후기 영역
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '상품 후기',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('총 $_reviewCount개'),
            ],
          ),
          const SizedBox(height: 12),
          ProductReviewSection(
            reviews: product.reviewList,
            onReviewCountChanged: _updateReviewCount, // ✅ 개수 반영 콜백
          ),

          const SizedBox(height: 24),

          // 🔽 문의 영역
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '상품 문의 >',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              FavoriteButton(
                isFavorite: product.isLiked,
                onToggle: toggleFavorite,
                size: 30,
                activeColor: Colors.pink,
                inactiveColor: Colors.black,
              ),
              IconButton(
                icon: const Icon(Icons.add_shopping_cart_outlined, size: 30),
                onPressed: () => _addToCart(context),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => showPurchaseSheet(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CommonColors.primary,
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
