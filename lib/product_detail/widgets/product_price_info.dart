import 'package:flutter/material.dart';

class ProductPriceInfo extends StatelessWidget {
  final int originalPrice;
  final int salePrice;

  const ProductPriceInfo({
    super.key,
    required this.originalPrice,
    required this.salePrice,
  });

  @override
  Widget build(BuildContext context) {
    final discount = (100 - salePrice / originalPrice * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$originalPrice원',
          style: const TextStyle(
            color: Colors.grey,
            decoration: TextDecoration.lineThrough,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Text(
              '$salePrice원',
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '-$discount%',
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
