import 'product.dart';

class CartItem {
  final Product product; // 장바구니에 담은 상품
  int quantity; // 상품의 수량
  bool selected; // 장바구니 화면에서 선택됐는지 여부
  CartItem({required this.product, this.quantity = 1, this.selected = false});
}
