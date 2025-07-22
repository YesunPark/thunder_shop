import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductPriceInfo extends StatelessWidget {
  final int originalPrice;
  final int? salePrice;

  const ProductPriceInfo({
    super.key,
    required this.originalPrice,
    required this.salePrice,
  });

  String formatPrice(int price) {
    return NumberFormat('#,###').format(price);
  }

  @override
  Widget build(BuildContext context) {
    // 할인가가 null, 0, 또는 원가와 같거나 더 크면: 할인 표시 X
    final bool hasDiscount =
        salePrice != null && salePrice! > 0 && salePrice! < originalPrice;

    final int displaySalePrice = hasDiscount ? salePrice! : originalPrice;
    final int discount = hasDiscount
        ? (100 - (salePrice! / originalPrice * 100)).round()
        : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasDiscount) // 원가 취소선은 할인가 있을 때만
          Text(
            '${formatPrice(originalPrice)}원',
            style: const TextStyle(
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
              fontSize: 14,
            ),
          ),
        if (hasDiscount) const SizedBox(height: 2),
        Row(
          children: [
            Text(
              '${formatPrice(displaySalePrice)}원',
              style: TextStyle(
                color: hasDiscount ? Colors.red : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            if (hasDiscount) ...[
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
          ],
        ),
      ],
    );
  }
}
