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
  final bool isRow;

  const ProductItem({
    required this.product,
    required this.cartItems,
    this.onAddToCart,
    this.isRow = false,
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isCard = !widget.isRow;

        Widget priceWidget() {
          if (isDiscount && widget.product.discountPrice != null) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${formatWithComma(widget.product.price)}원',
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (discountPercent != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: Text(
                          '${discountPercent}%',
                          style: const TextStyle(
                            color: Colors.orange,
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
              ],
            );
          } else {
            return Text('${formatWithComma(widget.product.price)}원');
          }
        }

        return GestureDetector(
          onTap: () => _goToDetailPage(context),
          child: widget.isRow
              ? Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 2,
                  color: Colors.white, // ✅ 카드 배경색 흰색으로 고정
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 이미지 + 하트
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Stack(
                            children: [
                              Image.asset(
                                widget.product.mainImageUrl,
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 90,
                                  height: 90,
                                  color: Colors.grey[300],
                                  alignment: Alignment.center,
                                  child: const Text('이미지'),
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
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),

                        // 상품 정보 + 버튼
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.product.productName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 6),
                              priceWidget(),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: OutlinedButton.icon(
                                  onPressed: () => _addToCart(context),
                                  icon: const Icon(
                                    Icons.shopping_cart_outlined,
                                    size: 18,
                                    color: CommonColors.primary,
                                  ),
                                  label: const Text(
                                    '담기',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    side: const BorderSide(
                                      color: CommonColors.primary,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 0,
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white, // ✅ 배경 흰색
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 이미지 + 하트 우상단
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
                      Text(
                        widget.product.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      priceWidget(),
                      const Spacer(),
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
                              side: const BorderSide(
                                color: CommonColors.primary,
                              ),
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
      },
    );
  }
}
