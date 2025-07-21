// 상품 클래스
class Product {
  final String id; // 고유 ID
  final String productName; // 상품명
  final String descImageUrl; // 상품 설명 이미지 URL
  final String category; // 카테고리
  final String categoryDetail; // 소분류 카테고리
  final int price; // 가격(원가)
  final int discountPrice; // 할인된 가격
  final String mainImageUrl; // 대표 이미지 URL
  final List<String> imageUrls; // 추가 이미지
  final String? videoUrl; // 동영상 URL (선택)
  final String shippingInfo; // 배송 정보
  final int shippingFee; // 배송비

  bool isLiked; // 좋아요 여부

  Product({
    required this.id,
    required this.productName,
    required this.descImageUrl,
    required this.category,
    required this.categoryDetail,
    required this.price,
    required this.discountPrice,
    required this.mainImageUrl,
    required this.imageUrls,
    this.videoUrl,
    required this.shippingInfo,
    required this.shippingFee,
    required this.isLiked,
  });
}
