import 'package:flutter/material.dart';
import 'package:thunder_shop/product_detail/product_detail_page.dart';
import 'package:thunder_shop/model/product.dart';
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

  @override
  Widget build(BuildContext context) {
    final imageBox = Stack(
      children: [
        Container(
          height: 150,
          color: Colors.grey[300],
          alignment: Alignment.center,
          child: const Text('이미지'),
        ),
        Positioned(
          top: 6,
          right: 6,
          child: FavoriteButton(
            isFavorite: widget.product.isLiked,
            onToggle: toggleFavorite,
            size: 24,
            activeColor: Colors.red,
            inactiveColor: Colors.grey,
          ),
        ),
      ],
    );

    final priceText = widget.product.discountPrice != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.product.price}원',
                style: const TextStyle(decoration: TextDecoration.lineThrough),
              ),
              Text(
                '${widget.product.discountPrice}원',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          )
        : Text('${widget.product.price}원');

    final tappableContent = GestureDetector(
      onTap: () => _goToDetailPage(context),
      behavior: HitTestBehavior.translucent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imageBox,
          const SizedBox(height: 8),
          Text(widget.product.productName),
          const SizedBox(height: 4),
          priceText,
        ],
      ),
    );

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: widget.isRow
          ? Row(
              children: [
                Expanded(child: tappableContent),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _addToCart(context),
                  child: const Text('담기'),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                tappableContent,
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => _addToCart(context),
                  child: const Text('담기'),
                ),
              ],
            ),
    );
  }
}
