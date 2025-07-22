import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thunder_shop/model/cart_item.dart';
import 'package:thunder_shop/model/product.dart';
import 'package:thunder_shop/product_detail/product_detail_page.dart';
import 'package:thunder_shop/style/common_colors.dart';
import 'package:thunder_shop/util/number_format_util.dart';

class ProductItem extends StatefulWidget {
  final Product product;
  final List<CartItem> cartItems;
  final void Function(Product)? onAddToCart;

  const ProductItem({
    required this.product,
    required this.cartItems,
    this.onAddToCart,
    super.key,
  });

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  void toggleFavorite() {
    setState(() {
      widget.product.isLiked = !widget.product.isLiked;
    });
  }

  void _addToCart(BuildContext context) {
    if (widget.onAddToCart != null) {
      widget.onAddToCart!(widget.product);
    }
  }

  void _goToDetailPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailPage(
          product: widget.product,
          onAddToCart: widget.onAddToCart!,
          cartItems: widget.cartItems,
        ),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  int? calcDiscountPercent(int price, int discountPrice) {
    if (price > 0 && discountPrice > 0 && discountPrice < price) {
      return ((100 * (price - discountPrice) / price).round());
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isDiscount =
        widget.product.discountPrice != null &&
        widget.product.discountPrice! < widget.product.price;
    final discountPercent = isDiscount
        ? calcDiscountPercent(
            widget.product.price,
            widget.product.discountPrice!,
          )
        : null;

    return GestureDetector(
      onTap: () => _goToDetailPage(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(14),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지 + 하트
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    widget.product.mainImageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 120,
                      width: double.infinity,
                      color: Colors.grey[300],
                      alignment: Alignment.center,
                      child: const Text('이미지'),
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: toggleFavorite,
                    child: Icon(
                      widget.product.isLiked
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: widget.product.isLiked
                          ? CommonColors.primary
                          : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 상품명
            Text(
              widget.product.productName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 4),

            // 가격
            if (widget.product.discountPrice != null &&
                widget.product.discountPrice != 0 &&
                widget.product.discountPrice! < widget.product.price) ...[
              // 원래 가격 (회색, 줄긋기)
              Text(
                '${formatWithComma(widget.product.price)}원',
                style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
              // 할인율 및 할인 가격
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (discountPercent != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: Text(
                        '${discountPercent}%',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  Text(
                    '${formatWithComma(widget.product.discountPrice!)}원',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ] else
              // 할인이 없을 때 (할인가 == 0 or null)
              Text(
                '${formatWithComma(widget.product.price)}원',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),

            const Spacer(), // 🔥 여기가 핵심! 남는 공간을 밀어줌
            // 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _addToCart(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: CommonColors.primary),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.shopping_cart_outlined,
                      color: CommonColors.primary,
                    ),
                    SizedBox(width: 6),
                    Text('담기'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
