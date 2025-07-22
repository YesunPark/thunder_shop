import 'dart:io';
import 'package:flutter/material.dart';
import 'package:thunder_shop/model/cart_item.dart';
import '../model/product.dart';
import 'widgets/product_image_slider.dart';
import 'widgets/product_price_info.dart';
import 'widgets/purchase_bottom_sheet.dart';
import 'widgets/product_review.dart';
import 'package:thunder_shop/model/favorite_button.dart';
import 'package:thunder_shop/style/common_colors.dart';
import 'package:thunder_shop/cart/cart_page.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  final List<CartItem> cartItems;
  final void Function(Product, int) onAddToCart;
  final bool isPreview;
  final int shippingFee;

  const ProductDetailPage({
    super.key,
    required this.product,
    required this.cartItems,
    required this.onAddToCart,
    this.isPreview = false,
    required this.shippingFee,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _currentIndex = 0;
  int _reviewCount = 0;

  List<String> get imageList {
    final List<String> images = [];
    // (1) 메인 이미지(로컬/네트워크)
    if (widget.product.mainImageUrl.isNotEmpty) {
      images.add(widget.product.mainImageUrl);
    }
    // (1) 추가 이미지들
    images.addAll(widget.product.imageUrls);

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
        product: widget.product,
        productName: widget.product.productName,
        originalPrice: widget.product.price,
        salePrice: widget.product.discountPrice,
        imageUrl: imageList[0],
        onAddToCart: widget.onAddToCart,
        shippingFee: widget.product.shippingFee, // 배송비 추가
      ),
    );
  }

  void _addToCart(BuildContext context) {
    widget.onAddToCart(widget.product, 1);
  }

  void _updateReviewCount(int count) {
    setState(() {
      _reviewCount = count;
    });
  }

  void _showInquiryDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white, // 흰색 배경
        contentPadding: const EdgeInsets.symmetric(
          vertical: 32,
          horizontal: 24,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "문의사항이 있으시면\ninfo@thundershop.com으로\n메일을 보내주시기 바랍니다.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 28),
            Center(
              child: SizedBox(
                width: 90,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
        // actions 생략 (content로 직접 배치)
      ),
    );
  }

  /*
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '상품 등록이 완료되었습니다.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 28),
            Center(
              child: SizedBox(
                width: 90,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
*/

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    // (7) 리뷰 배열
    final hasReviews =
        product.reviewList != null && product.reviewList.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white, // (2)
      appBar: AppBar(
        title: const Text('상품 상세'),
        centerTitle: true,
        leading: const BackButton(),
        elevation: 0,
        backgroundColor: Colors.white, // (2)
        surfaceTintColor: Colors.white, // (2)
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
              color: widget.isPreview ? Colors.grey[300] : Colors.black, // (2)
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // (1) 이미지 슬라이더 - 로컬/네트워크 자동 분기
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
          // (4) 할인 없는 경우 할인 UI X
          ProductPriceInfo(
            originalPrice: product.price,
            salePrice: (product.discountPrice != 0)
                ? product.discountPrice
                : null,
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
          // (1) 상품설명 이미지: 로컬/네트워크 자동 분기
          if (product.descImageUrl.isNotEmpty)
            SizedBox(
              height: 200,
              width: double.infinity,
              child: product.descImageUrl.startsWith('http')
                  ? Image.network(
                      product.descImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(child: Icon(Icons.broken_image)),
                    )
                  : Image.file(
                      File(product.descImageUrl),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(child: Icon(Icons.broken_image)),
                    ),
            ),
          const SizedBox(height: 24),

          // (7) 리뷰 없으면 섹션 자체 숨김
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '상품 후기',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('총 ${product.reviewList.length}개'),
            ],
          ),
          const SizedBox(height: 12),
          ProductReviewSection(
            reviews: product.reviewList,
            onReviewCountChanged: _updateReviewCount,
          ),
          const SizedBox(height: 24),

          // 문의 영역
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: _showInquiryDialog, // (5)
                child: const Text(
                  '상품 문의 >',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: CommonColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
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
                activeColor: widget.isPreview
                    ? Colors.grey[300]!
                    : CommonColors.primary, // (3)
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
                        borderRadius: BorderRadius.circular(14), // (6)
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
