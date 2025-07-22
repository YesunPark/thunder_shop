import 'dart:io';

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
  final bool isPreview;

  const ProductDetailPage({
    super.key,
    required this.product,
    required this.cartItems,
    required this.onAddToCart,
    this.isPreview = false,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _currentIndex = 0;
  int _reviewCount = 0; // ✅ 리뷰 개수 상태
  bool _showInquiryForm = false;

  List<String> get imageList {
    final List<String> images = [];

    // 대표 이미지가 있으면 가장 앞에 추가
    if (widget.product.mainImageUrl.isNotEmpty) {
      images.add(widget.product.mainImageUrl);
    }

    // 추가 이미지들도 포함
    images.addAll(widget.product.imageUrls);

    // 아무것도 없을 경우 기본 이미지
    if (images.isEmpty) {
      images.add('https://picsum.photos/seed/${widget.product.id}/300/250');
    }

    return images;
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
            onPressed: widget.isPreview
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CartPage(cartItems: widget.cartItems),
                      ),
                    );
                  },
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: widget.isPreview ? Colors.grey[300] : Colors.white,
            ),
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
          SizedBox(
            height: 200,
            width: double.infinity,
            child: Image.file(
              File(widget.product.descImageUrl),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Center(child: Icon(Icons.broken_image)),
            ),
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
                onToggle: () {
                  if (!widget.isPreview) {
                    toggleFavorite();
                  }
                },
                size: 30,
                activeColor: widget.isPreview ? Colors.grey[300]! : Colors.pink,
                inactiveColor: widget.isPreview
                    ? Colors.grey[300]!
                    : Colors.black,
              ),
              IconButton(
                icon: Icon(
                  Icons.add_shopping_cart_outlined,
                  size: 30,
                  color: widget.isPreview ? Colors.grey[300] : Colors.black,
                ),
                onPressed: widget.isPreview ? null : () => _addToCart(context),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: widget.isPreview
                        ? null
                        : () => showPurchaseSheet(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.isPreview
                          ? Colors.grey[300]
                          : CommonColors.primary,
                      foregroundColor: widget.isPreview
                          ? Colors.grey[500]
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text(
                      '구매하기',
                      style: TextStyle(
                        fontSize: 16,
                        color: widget.isPreview
                            ? Colors.grey[500]
                            : Colors.white,
                      ),
                    ),
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
