// 상품 container

import 'package:flutter/material.dart';

class ProductItem extends StatefulWidget {
  final String name;
  final int price;
  final int? salePrice;
  final bool isRow;

  const ProductItem({
    required this.name,
    required this.price,
    this.salePrice,
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
    // 실제 앱에서는 장바구니에 상품을 추가하는 로직 필요
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('장바구니에 추가되었습니다')));
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

    final priceText = widget.salePrice != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.price}원',
                style: const TextStyle(decoration: TextDecoration.lineThrough),
              ),
              Text('${widget.salePrice}원'),
            ],
          )
        : Text('${widget.price}원');

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        imageBox,
        const SizedBox(height: 8),
        ElevatedButton(onPressed: addToCart, child: const Text('담기')),
        const SizedBox(height: 4),
        Text(widget.name),
        priceText,
      ],
    );

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: widget.isRow ? Row(children: [Expanded(child: content)]) : content,
    );
  }
}
