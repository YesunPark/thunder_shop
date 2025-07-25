import 'package:flutter/material.dart';
import 'package:thunder_shop/style/common_colors.dart';
import 'package:thunder_shop/model/product.dart';
import 'package:intl/intl.dart';

class PurchaseBottomSheet extends StatefulWidget {
  final Product product;
  // product를 추가해야해서 추가했습니다.
  // 원래라면 productName, originalPrice, salePrice를 삭제하고 product 내의 값으로 대체해야 하지만
  // 원활한 병합을 위해 일단 두겠습니다...ㅎㅎ - 예선
  final String productName;
  final int originalPrice;
  final int salePrice;
  final String imageUrl;
  final void Function(Product, int) onAddToCart;
  final int shippingFee; // 배송비 추가

  const PurchaseBottomSheet({
    super.key,
    required this.product,
    required this.productName,
    required this.originalPrice,
    required this.salePrice,
    required this.imageUrl,
    required this.onAddToCart,
    required this.shippingFee, // 배송비 추가
  });

  @override
  State<PurchaseBottomSheet> createState() => _PurchaseBottomSheetState();
}

final numberFormat = NumberFormat('#,###');

class _PurchaseBottomSheetState extends State<PurchaseBottomSheet> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final totalPrice =
        (widget.salePrice == 0 ? widget.originalPrice : widget.salePrice) *
            quantity +
        widget.shippingFee;

    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset(widget.imageUrl, fit: BoxFit.cover),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.productName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              if (quantity > 1) {
                                setState(() => quantity--);
                              }
                            },
                          ),
                          Text(
                            '$quantity',
                            style: const TextStyle(fontSize: 16),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => setState(() => quantity++),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // 할인 있을 때만 찍찍이
                    if (widget.salePrice != null && widget.salePrice != 0)
                      Text(
                        '${numberFormat.format(widget.originalPrice)}원',
                        style: const TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      // 할인 없으면 원래가격을 볼드+검정으로
                      '${numberFormat.format((widget.salePrice == null || widget.salePrice == 0) ? widget.originalPrice : widget.salePrice)}원',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color:
                            (widget.salePrice == null || widget.salePrice == 0)
                            ? Colors
                                  .black // 할인 없으면 검정
                            : Colors.red, // 할인 있으면 빨강
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '배송비 ${numberFormat.format(widget.shippingFee)}원',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '결제금액',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${numberFormat.format(totalPrice)}원', // ← 콤마 찍기!
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Row(
              children: [
                // 장바구니 icon
                IconButton(
                  icon: const Icon(Icons.add_shopping_cart_outlined, size: 28),
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onAddToCart(widget.product, quantity);
                  },
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: SizedBox(
                            height: 48,
                            child: Center(
                              child: Text(
                                '\n바로 결제하시겠습니까?',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18, // 원하는 만큼 더 키워도 됨
                                ),
                              ),
                            ),
                          ),
                          actionsAlignment: MainAxisAlignment.center,
                          actions: [
                            SizedBox(
                              width: 80,
                              child: TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('취소'),
                              ),
                            ),
                            SizedBox(
                              width: 80,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('구매가 완료되었습니다'),
                                    ),
                                  );
                                },
                                child: const Text('확인'),
                              ),
                            ),
                          ],
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      );
                    },

                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: CommonColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('구매하기', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
