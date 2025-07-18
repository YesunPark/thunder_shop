import 'package:flutter/material.dart';
import 'package:thunder_shop/product_detail/product_detail_page.dart'; // 상세 페이지 import
import 'package:thunder_shop/model/product.dart';

class ProductItem extends StatefulWidget {
  final Product product;
  final VoidCallback? onTap; // ProductItem을 눌렀을 때 동작하는 로직을 목록화면에서 받아온다.
  final void Function(Product)? onAddToCart; // 장바구니 추가 로직을 목록화면에서 받아온다.
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
  bool isFavorite = false;

  // 찜하기 / 찜 해제
  void toggleFavorite() {
    setState(() => isFavorite = !isFavorite);
  }

  // 장바구니 추가 로직
  void _addToCart(BuildContext context) {
    if (widget.onAddToCart != null) {
      widget.onAddToCart!(widget.product);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('장바구니에 추가되었습니다')));
    }
  }

  // 상세페이지 이동 로직
  void _goToDetailPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProductDetailPage()),
    );
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
          child: IconButton(
            onPressed: toggleFavorite,
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.grey,
              size: 24,
            ),
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

    // 상세 페이지로 이동할 영역을 GestureDetector로 감쌈
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
