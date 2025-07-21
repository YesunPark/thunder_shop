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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
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
            Text(
              '$salePrice원',
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        Text(
          '-$discount%',
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
