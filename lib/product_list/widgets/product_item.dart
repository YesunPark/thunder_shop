import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 👈 꼭 추가!
import 'package:thunder_shop/model/product.dart';
import 'package:thunder_shop/product_detail/product_detail_page.dart';
import 'package:thunder_shop/model/favorite_button.dart';

class ProductItem extends StatefulWidget {
  final Product product;
  final VoidCallback? onTap;
  final void Function(Product)? onAddToCart;
  final bool isRow;

  const ProductItem({
    required this.product,
    this.onTap,
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('장바구니에 추가되었습니다')));
    }
  }

  void _goToDetailPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailPage(product: widget.product),
      ),
    ).then((_) {
      // 상세페이지에서 돌아올 때 상태 갱신
      setState(() {});
    });
  }

  String formatPrice(int price) {
    return NumberFormat('#,###').format(price);
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
        widget.product.discountPrice < widget.product.price;
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
                  '${formatPrice(widget.product.price)}원',
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
                      '${formatPrice(widget.product.discountPrice!)}원',
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
            return Text('${formatPrice(widget.product.price)}원');
          }
        }

        return GestureDetector(
          onTap: () => _goToDetailPage(context),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(14),
              color: Colors.white,
            ),
            child: isCard
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 120,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: const Text('이미지'),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: toggleFavorite,
                              icon: Icon(
                                widget.product.isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: widget.product.isLiked
                                    ? Colors.red
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
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('담기'),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: const Text('이미지'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.productName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            priceWidget(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () => _addToCart(context),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('담기'),
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
