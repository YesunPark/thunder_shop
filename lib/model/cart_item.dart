import 'product.dart';

class CartItem {
  final Product product;
  int quantity;
  bool selected;
  CartItem({required this.product, this.quantity = 1, this.selected = false});
}
