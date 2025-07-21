import 'package:flutter/material.dart';
import '../../model/product.dart';

class ProductReviewSection extends StatelessWidget {
  final List<ProductReview> reviews;

  const ProductReviewSection({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('작성된 리뷰가 없습니다.'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            '리뷰',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final review = reviews[index];
            return ListTile(
              leading: const Icon(Icons.person_outline),
              title: Text(review.userName),
              subtitle: Text(review.content),
            );
          },
        ),
      ],
    );
  }
}
