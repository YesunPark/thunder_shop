import 'package:flutter/material.dart';
import 'package:thunder_shop/model/cart_item.dart';
import 'package:thunder_shop/product_list/product_list_page.dart';
import 'package:thunder_shop/util/number_format_util.dart';
import 'package:thunder_shop/style/common_colors.dart';

class CartPage extends StatefulWidget {
  final List<CartItem> cartItems;
  const CartPage({Key? key, required this.cartItems}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> get cartItems => widget.cartItems;

  // 상품 전체 선택 여부
  bool get allSelected => cartItems.every((item) => item.selected);

  // 상품 원가 총합 금액
  int get totalProductPrice => cartItems
      .where((item) => item.selected)
      .fold(0, (sum, item) => sum + item.product.price * item.quantity);

  // 총 배송비 금액
  int get totalShippingFee => cartItems
      .where((item) => item.selected)
      .fold(0, (sum, item) => sum + item.product.shippingFee);

  // 총 할인된 금액
  int get totalDiscount => cartItems.where((item) => item.selected).fold(0, (
    sum,
    item,
  ) {
    // discountPrice가 0이면 원가(price)로 대체
    final effectiveDiscountPrice = item.product.discountPrice == 0
        ? item.product.price
        : item.product.discountPrice;
    // (원가 - 할인된 가격) * 수량
    return sum + (item.product.price - effectiveDiscountPrice) * item.quantity;
  });

  // 총 결제 금액
  int get totalPay => totalProductPrice - totalDiscount + totalShippingFee;

  // 선택된 상품 개수
  int get totalCount => cartItems
      .where((item) => item.selected)
      .fold(0, (sum, item) => sum + item.quantity);

  @override
  void initState() {
    super.initState();
    for (var item in cartItems) {
      item.selected = true;
    }
  }

  void toggleAll(bool? value) {
    setState(() {
      for (var item in cartItems) {
        item.selected = value ?? false;
      }
    });
  }

  // 상품 선택 유무 핸들링 로직
  void toggleItem(int idx, bool? value) {
    setState(() {
      cartItems[idx].selected = value ?? false;
    });
  }

  // 상품 수량 조절 로직
  void changeQuantity(int idx, int delta) {
    setState(() {
      int newQty = cartItems[idx].quantity + delta;
      if (newQty > 0) cartItems[idx].quantity = newQty;
    });
  }

  // 장바구니에서 상품 삭제 로직
  void removeItem(int idx) {
    setState(() {
      cartItems.removeAt(idx);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEmpty = cartItems.isEmpty;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('장바구니'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        surfaceTintColor: Colors.white,
      ),
      body: isEmpty
          // 빈 장바구니 화면
          ? EmptyCart()
          // 담긴 상품 목록
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                    itemCount: cartItems.length + 1,
                    itemBuilder: (context, idx) {
                      if (idx < cartItems.length) {
                        // 장바구니에 담긴 상품 카드
                        return CartItemCard(
                          item: cartItems[idx],
                          onRemove: () => removeItem(idx),
                          onDecrease: () => changeQuantity(idx, -1),
                          onIncrease: () => changeQuantity(idx, 1),
                          onSelect: (v) => toggleItem(idx, v),
                        );
                      } else {
                        // 마지막 총 금액 정보 표시란
                        return TotalPriceInfo(
                          totalProductPrice: totalProductPrice,
                          totalShippingFee: totalShippingFee,
                          totalDiscount: totalDiscount,
                          totalPay: totalPay,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),

      // 최하단 구매하기 버튼
      bottomNavigationBar: isEmpty
          ? null
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey[300]!)),
              ),
              child: Row(
                children: [
                  Checkbox(
                    value: allSelected,
                    onChanged: toggleAll,
                    activeColor: CommonColors.primary,
                    checkColor: Colors.white,
                  ),
                  Text('모두 선택'),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CommonColors.primary,
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: totalCount > 0
                          ? () {
                              _showPaymentDialog();
                            }
                          : null,
                      child: Text(
                        '총 ${totalCount}개 상품 ${formatWithComma(totalPay)}원 구매하기',
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // 구매완료 팝업 표시
  void _showPaymentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.fromLTRB(24, 30, 0, 10),
        content: Text(
          '총 ${formatWithComma(totalPay)}원 결제되었습니다.',
          style: TextStyle(fontSize: 16),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        // actions 영역의 패딩 (버튼과 테두리 간격)
        actionsPadding: const EdgeInsets.only(right: 16, bottom: 8),
        actions: [
          TextButton(
            style: ButtonStyle(
              // 눌렀을 때 보라색 대신 회색 오버레이
              overlayColor: MaterialStateProperty.all(Colors.grey.shade200),
            ),
            onPressed: () {
              // 다이얼로그 닫기
              Navigator.of(context).pop();

              // 상품 목록으로 이동
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => ProductListPage()),
              );
            },
            child: Text('확인', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}

/*
 * 빈 장바구니 위젯 
 */
class EmptyCart extends StatelessWidget {
  const EmptyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 24),
          Text(
            '장바구니에 담긴 상품이 없어요',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '원하는 상품을 담아보세요!',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 32),
          SizedBox(
            width: 180,
            height: 40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: CommonColors.primary,
                foregroundColor: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                '상품 담으러 가기',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*
 * 장바구니 상품 카드
 */
class CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onRemove;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final ValueChanged<bool?> onSelect;

  const CartItemCard({
    Key? key,
    required this.item,
    required this.onRemove,
    required this.onDecrease,
    required this.onIncrease,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      elevation: 0.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.zero,
              child: Checkbox(
                value: item.selected,
                onChanged: onSelect,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                activeColor: CommonColors.primary,
                checkColor: Colors.white,
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                width: 60,
                height: 80,
                color: Colors.grey[300],
                child: item.product.mainImageUrl.isNotEmpty
                    ? Image.asset(item.product.mainImageUrl, fit: BoxFit.cover)
                    : Icon(Icons.image, size: 40, color: Colors.grey[500]),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.productName,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: onDecrease,
                            iconSize: 20,
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints.tightFor(
                              width: 20,
                              height: 20,
                            ),
                            visualDensity: VisualDensity.compact,
                            alignment: Alignment.center,
                          ),
                          Container(
                            width: 20,
                            height: 18,
                            alignment: Alignment.center,
                            child: Text(
                              '${item.quantity}',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: onIncrease,
                            iconSize: 20,
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints.tightFor(
                              width: 20,
                              height: 20,
                            ),
                            visualDensity: VisualDensity.compact,
                            alignment: Alignment.center,
                          ),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // 원가
                            if (item.product.discountPrice != 0) ...[
                              Text(
                                '${formatWithComma(item.product.price)}원',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              SizedBox(height: 3),
                            ],

                            // 할인가(판매가)
                            Text(
                              '${formatWithComma(item.product.discountPrice != 0 ? item.product.discountPrice : item.product.price)}원',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 3),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '배송비',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(fontSize: 10),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  '${formatWithComma(item.product.shippingFee)}원',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: onRemove,
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              alignment: Alignment.topCenter,
            ),
          ],
        ),
      ),
    );
  }
}

/*
 * 장바구니 총 가격 정보 
 */
class TotalPriceInfo extends StatelessWidget {
  final int totalProductPrice;
  final int totalShippingFee;
  final int totalDiscount;
  final int totalPay;

  const TotalPriceInfo({
    Key? key,
    required this.totalProductPrice,
    required this.totalShippingFee,
    required this.totalDiscount,
    required this.totalPay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('총 상품 금액'),
              Text('${formatWithComma(totalProductPrice)} 원'),
            ],
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('총 배송비'),
              Text('+ ${formatWithComma(totalShippingFee)} 원'),
            ],
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('총 할인 금액'),
              Text('- ${formatWithComma(totalDiscount)} 원'),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '결제 금액',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '${formatWithComma(totalPay)} 원',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
