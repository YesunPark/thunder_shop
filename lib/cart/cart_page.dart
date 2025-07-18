import 'package:flutter/material.dart';
import '../model/product.dart';

class CartItem {
  final Product product;
  int quantity;
  bool selected;
  CartItem({required this.product, this.quantity = 1, this.selected = false});
}

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // 더미 데이터
  List<CartItem> cartItems = [
    CartItem(
      product: Product(
        id: '1',
        productName: '상품1',
        descImageUrl: '',
        category: '카테고리',
        categoryDetail: '소분류',
        price: 20000,
        discountPrice: 15000,
        mainImageUrl: '',
        imageUrls: [],
        shippingInfo: '무료배송',
        shippingFee: 0,
      ),
      quantity: 3,
      selected: false,
    ),
    CartItem(
      product: Product(
        id: '2',
        productName: '상품2',
        descImageUrl: '',
        category: '카테고리',
        categoryDetail: '소분류',
        price: 30000,
        discountPrice: 25000,
        mainImageUrl: '',
        imageUrls: [],
        shippingInfo: '배송비 3,000원',
        shippingFee: 3000,
      ),
      quantity: 1,
      selected: false,
    ),
    CartItem(
      product: Product(
        id: '3',
        productName: '상품2',
        descImageUrl: '',
        category: '카테고리',
        categoryDetail: '소분류',
        price: 30000,
        discountPrice: 25000,
        mainImageUrl: '',
        imageUrls: [],
        shippingInfo: '배송비 3,000원',
        shippingFee: 3000,
      ),
      quantity: 1,
      selected: false,
    ),
    CartItem(
      product: Product(
        id: '4',
        productName: '상품2',
        descImageUrl: '',
        category: '카테고리',
        categoryDetail: '소분류',
        price: 30000,
        discountPrice: 25000,
        mainImageUrl: '',
        imageUrls: [],
        shippingInfo: '배송비 3,000원',
        shippingFee: 3000,
      ),
      quantity: 1,
      selected: false,
    ),
    CartItem(
      product: Product(
        id: '5',
        productName: '상품2',
        descImageUrl: '',
        category: '카테고리',
        categoryDetail: '소분류',
        price: 30000,
        discountPrice: 25000,
        mainImageUrl: '',
        imageUrls: [],
        shippingInfo: '배송비 3,000원',
        shippingFee: 3000,
      ),
      quantity: 1,
      selected: false,
    ),
  ];

  bool get allSelected => cartItems.every((item) => item.selected);
  int get totalProductPrice => cartItems
      .where((item) => item.selected)
      .fold(0, (sum, item) => sum + item.product.discountPrice * item.quantity);
  int get totalShippingFee => cartItems
      .where((item) => item.selected)
      .fold(0, (sum, item) => sum + item.product.shippingFee);
  int get totalDiscount => cartItems
      .where((item) => item.selected)
      .fold(
        0,
        (sum, item) =>
            sum +
            (item.product.price - item.product.discountPrice) * item.quantity,
      );
  int get totalCount => cartItems
      .where((item) => item.selected)
      .fold(0, (sum, item) => sum + item.quantity);
  int get totalPay => totalProductPrice + totalShippingFee;

  void toggleAll(bool? value) {
    setState(() {
      for (var item in cartItems) {
        item.selected = value ?? false;
      }
    });
  }

  void toggleItem(int idx, bool? value) {
    setState(() {
      cartItems[idx].selected = value ?? false;
    });
  }

  void changeQuantity(int idx, int delta) {
    setState(() {
      int newQty = cartItems[idx].quantity + delta;
      if (newQty > 0) cartItems[idx].quantity = newQty;
    });
  }

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
          ? Center(
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
                        backgroundColor: const Color.fromARGB(
                          255,
                          80,
                          115,
                          255,
                        ),
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
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
            )
          // 담긴 상품 목록
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                    itemCount: cartItems.length + 1,
                    itemBuilder: (context, idx) {
                      if (idx < cartItems.length) {
                        final item = cartItems[idx];
                        return Card(
                          margin: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 5,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.zero,
                                  child: Checkbox(
                                    value: item.selected,
                                    onChanged: (v) => toggleItem(idx, v),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),

                                // 상품 이미지
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Container(
                                    width: 60,
                                    height: 80,
                                    color: Colors.grey[300],
                                    child: item.product.mainImageUrl.isNotEmpty
                                        ? Image.network(
                                            item.product.mainImageUrl,
                                            fit: BoxFit.cover,
                                          )
                                        : Icon(
                                            Icons.image,
                                            size: 40,
                                            color: Colors.grey[500],
                                          ),
                                  ),
                                ),
                                SizedBox(width: 12),

                                // 상품 이름
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.product.productName,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),

                                      // 상품 수량 조절란
                                      Row(
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.remove),
                                                onPressed: () =>
                                                    changeQuantity(idx, -1),
                                                iconSize: 20,
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    BoxConstraints.tightFor(
                                                      width: 20,
                                                      height: 20,
                                                    ),
                                                visualDensity:
                                                    VisualDensity.compact,
                                                alignment: Alignment.center,
                                              ),
                                              Container(
                                                width: 20,
                                                height: 18,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  '${item.quantity}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.add),
                                                onPressed: () =>
                                                    changeQuantity(idx, 1),
                                                iconSize: 20,
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    BoxConstraints.tightFor(
                                                      width: 20,
                                                      height: 20,
                                                    ),
                                                visualDensity:
                                                    VisualDensity.compact,
                                                alignment: Alignment.center,
                                              ),
                                            ],
                                          ),

                                          // 상품 별 가격 기재란
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                // 원가
                                                Text(
                                                  '${item.product.price}원',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.grey,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                  ),
                                                ),
                                                SizedBox(height: 3),
                                                // 할인가
                                                Text(
                                                  '${item.product.discountPrice}원',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(height: 3),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '배송비',
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      '${item.product.shippingFee}원',
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                      ),
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
                                  onPressed: () => removeItem(idx),
                                  padding: EdgeInsets.zero,
                                  visualDensity: VisualDensity.compact,
                                  alignment: Alignment.topCenter,
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        // 마지막에 총 금액 정보 표시
                        return Container(
                          color: Colors.white,
                          margin: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('총 상품 금액'),
                                  Text('${totalProductPrice} 원'),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('총 배송비'),
                                  Text('+${totalShippingFee} 원'),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('총 할인 금액'),
                                  Text('-${totalDiscount} 원'),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '결제 금액',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${totalPay} 원',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
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
                  Checkbox(value: allSelected, onChanged: toggleAll),
                  Text('모두 선택'),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: totalCount > 0 ? () {} : null,
                      child: Text('총 ${totalCount}개 상품 ${totalPay}원 구매하기'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
