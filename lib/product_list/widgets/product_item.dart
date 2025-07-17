import 'package:flutter/material.dart';

class ProductItem extends StatefulWidget {
  final String productName; // name → productName
  final int price;
  final int? discountPrice; // salePrice → discountPrice
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
              Text('${widget.discountPrice}원'),
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
        Text(widget.productName), // 변경된 부분
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
