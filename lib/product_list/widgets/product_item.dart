import 'package:flutter/material.dart';
import 'package:thunder_shop/product_detail/product_detail_page.dart'; // 상세 페이지 import

class ProductItem extends StatefulWidget {
  final String productName;
  final int price;
  final int? discountPrice;
  final bool isRow;

  const ProductItem({
    required this.productName,
    required this.price,
    this.discountPrice,
    this.isRow = false,
    super.key,
  });

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  bool isFavorite = false;

  void toggleFavorite() {
    setState(() => isFavorite = !isFavorite);
  }

  void addToCart() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('장바구니에 추가되었습니다')));
  }

  void goToDetailPage() {
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

    final priceText = widget.discountPrice != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.price}원',
                style: const TextStyle(decoration: TextDecoration.lineThrough),
              ),
              Text(
                '${widget.discountPrice}원',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          )
        : Text('${widget.price}원');

    // 상세 페이지로 이동할 영역을 GestureDetector로 감쌈
    final tappableContent = GestureDetector(
      onTap: goToDetailPage,
      behavior: HitTestBehavior.translucent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imageBox,
          const SizedBox(height: 8),
          Text(widget.productName),
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
                ElevatedButton(onPressed: addToCart, child: const Text('담기')),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                tappableContent,
                const SizedBox(height: 8),
                ElevatedButton(onPressed: addToCart, child: const Text('담기')),
              ],
            ),
    );
  }
}
