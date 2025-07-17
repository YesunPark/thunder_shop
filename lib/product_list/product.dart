// 상품 클래스
class Product {
  final String id; // 고유 ID
  final String productName; // 상품명
  final String description; // 상품 설명
  final String category; // 카테고리
  final int price; // 가격
  final int discountPrice; // 할인 가격
  final String imageUrl; // 대표 이미지 URL
  final List<String> imageUrls; // 추가 이미지
  final String seller; // 판매자명
  // 동영상(선택)

  Product({
    required this.id,
    required this.productName,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPrice,
    required this.imageUrl,
    required this.imageUrls,
    required this.seller,
  });

  // Map -> Product
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String,
      productName: map['title'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      price: map['price'] as int,
      discountPrice: map['discountPrice'] as int,
      imageUrl: map['imageUrl'] as String,
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      seller: map['seller'] as String,
    );
  }

  // Product -> Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productName': productName,
      'description': description,
      'category': category,
      'price': price,
      'discountPrice': discountPrice,
      'imageUrl': imageUrl,
      'imageUrls': imageUrls,
      'seller': seller,
    };
  }
}
