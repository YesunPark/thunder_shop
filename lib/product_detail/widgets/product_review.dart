import 'package:flutter/material.dart';
import '../../model/product.dart';

class ProductReviewSection extends StatelessWidget {
  final List<ProductReview> reviews;
  final void Function(int)? onReviewCountChanged; // ✅ 리뷰 수 전달 콜백

  const ProductReviewSection({
    super.key,
    required this.reviews,
    this.onReviewCountChanged,
  });

  @override
  Widget build(BuildContext context) {
    // 임의 리뷰 데이터 (나중에 제거 예정)
    final List<ProductReview> dummyReviews = [
      ProductReview(userName: '홍길동', content: '정말 만족스러운 제품이에요!'),
      ProductReview(userName: '김민지', content: '배송도 빠르고 품질도 좋아요.'),
      ProductReview(userName: '이준호', content: '가성비 최고입니다. 다음에도 구매할게요.'),
    ];

    final List<ProductReview> displayReviews = reviews.isEmpty
        ? dummyReviews
        : reviews;

    // 콜백으로 리뷰 수 전달 (build 후 실행)
    if (onReviewCountChanged != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onReviewCountChanged!(displayReviews.length);
      });
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
          itemCount: displayReviews.length,
          itemBuilder: (context, index) {
            final review = displayReviews[index];
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
