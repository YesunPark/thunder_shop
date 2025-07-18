import 'package:flutter/material.dart';
import 'package:thunder_shop/model/product.dart';
import 'package:thunder_shop/product_register/product_register_page.dart';
import '../cart/cart_page.dart';

import 'widgets/category_selector.dart';
import 'widgets/product_item.dart';

// ------- 샘플 상품 데이터 --------
List<Product> allProducts = [
  Product(
    id: '1',
    productName: '[하림] 닭가슴살 오리지널 1kg',
    descImageUrl: '',
    category: '식품',
    categoryDetail: '닭가슴살',
    price: 11000,
    discountPrice: 8900,
    mainImageUrl: '',
    imageUrls: [],
    videoUrl: null,
    shippingInfo: 'CJ대한통운',
    shippingFee: 3000,
    isLiked: false,
  ),
  Product(
    id: '2',
    productName: '[마이닭] 훈제 닭가슴살 800g',
    descImageUrl: '',
    category: '식품',
    categoryDetail: '닭가슴살',
    price: 10500,
    discountPrice: 7900,
    mainImageUrl: '',
    imageUrls: [],
    videoUrl: null,
    shippingInfo: 'CJ대한통운',
    shippingFee: 3000,
    isLiked: false,
  ),
  Product(
    id: '3',
    productName: '[마이프로틴] 임팩트 웨이 프로틴 1kg',
    descImageUrl: '',
    category: '식품',
    categoryDetail: '프로틴',
    price: 35000,
    discountPrice: 28500,
    mainImageUrl: '',
    imageUrls: [],
    videoUrl: null,
    shippingInfo: 'CJ대한통운',
    shippingFee: 3000,
    isLiked: false,
  ),
  Product(
    id: '4',
    productName: '[옵티멈] 골드 스탠다드 907g',
    descImageUrl: '',
    category: '식품',
    categoryDetail: '프로틴',
    price: 42000,
    discountPrice: 34900,
    mainImageUrl: '',
    imageUrls: [],
    videoUrl: null,
    shippingInfo: 'CJ대한통운',
    shippingFee: 3000,
    isLiked: false,
  ),
  Product(
    id: '5',
    productName: '[몬스터] 에너지 울트라 355ml*12',
    descImageUrl: '',
    category: '식품',
    categoryDetail: '에너지드링크',
    price: 18000,
    discountPrice: 14400,
    mainImageUrl: '',
    imageUrls: [],
    videoUrl: null,
    shippingInfo: 'CJ대한통운',
    shippingFee: 3000,
    isLiked: false,
  ),
  Product(
    id: '6',
    productName: '[레드불] 에너지드링크 250ml*6',
    descImageUrl: '',
    category: '식품',
    categoryDetail: '에너지드링크',
    price: 14000,
    discountPrice: 10500,
    mainImageUrl: '',
    imageUrls: [],
    videoUrl: null,
    shippingInfo: 'CJ대한통운',
    shippingFee: 3000,
    isLiked: false,
  ),
  Product(
    id: '7',
    productName: '[프레시지] 닭가슴살 곡물 샐러드',
    descImageUrl: '',
    category: '식품',
    categoryDetail: '샐러드',
    price: 7500,
    discountPrice: 5900,
    mainImageUrl: '',
    imageUrls: [],
    videoUrl: null,
    shippingInfo: 'CJ대한통운',
    shippingFee: 3000,
    isLiked: false,
  ),
  Product(
    id: '8',
    productName: '[샐러디] 오리엔탈 치킨 샐러드',
    descImageUrl: '',
    category: '식품',
    categoryDetail: '샐러드',
    price: 8000,
    discountPrice: 6200,
    mainImageUrl: '',
    imageUrls: [],
    videoUrl: null,
    shippingInfo: 'CJ대한통운',
    shippingFee: 3000,
    isLiked: false,
  ),

  // --- 운동보조제
  Product(
    id: '9',
    productName: '[머슬팜] 크레아틴 300g',
    descImageUrl: '',
    category: '운동보조제',
    categoryDetail: '크레아틴',
    price: 24000,
    discountPrice: 18500,
    mainImageUrl: '',
    imageUrls: [],
    videoUrl: null,
    shippingInfo: 'CJ대한통운',
    shippingFee: 3000,
    isLiked: false,
  ),
  Product(
    id: '10',
    productName: '[나우푸드] 크레아틴 모노 500g',
    descImageUrl: '',
    category: '운동보조제',
    categoryDetail: '크레아틴',
    price: 29000,
    discountPrice: 22800,
    mainImageUrl: '',
    imageUrls: [],
    videoUrl: null,
    shippingInfo: 'CJ대한통운',
    shippingFee: 3000,
    isLiked: false,
  ),
  Product(
    id: '11',
    productName: '[엑스텐드] BCAA 420g',
    descImageUrl: '',
    category: '운동보조제',
    categoryDetail: 'BCAA/아미노산',
    price: 38000,
    discountPrice: 29900,
    mainImageUrl: '',
    imageUrls: [],
    videoUrl: null,
    shippingInfo: 'CJ대한통운',
    shippingFee: 3000,
    isLiked: false,
  ),
  Product(
    id: '12',
    productName: '[머슬팜] BCAA 30서빙',
    descImageUrl: '',
    category: '운동보조제',
    categoryDetail: 'BCAA/아미노산',
    price: 32000,
    discountPrice: 25500,
    mainImageUrl: '',
    imageUrls: [],
    videoUrl: null,
    shippingInfo: 'CJ대한통운',
    shippingFee: 3000,
    isLiked: false,
  ),
  Product(
    id: '13',
    productName: '[셀코어] 프리워크아웃 250g',
    descImageUrl: '',
    category: '운동보조제',
    categoryDetail: '프리워크아웃',
    price: 39000,
    discountPrice: 31200,
    mainImageUrl: '',
    imageUrls: [],
    videoUrl: null,
    shippingInfo: 'CJ대한통운',
    shippingFee: 3000,
    isLiked: false,
  ),
  Product(
    id: '14',
    productName: '[프로섭스] 하이드 220g',
    descImageUrl: '',
    category: '운동보조제',
    categoryDetail: '프리워크아웃',
    price: 44000,
    discountPrice: 35500,
    mainImageUrl: '',
    imageUrls: [],
    videoUrl: null,
    shippingInfo: 'CJ대한통운',
    shippingFee: 3000,
    isLiked: false,
  ),
  Product(
    id: '15',
    productName: '[센트룸] 멀티비타민 100정',
    descImageUrl: '',
    category: '운동보조제',
    categoryDetail: '비타민',
    price: 28000,
    discountPrice: 21900,
    mainImageUrl: '',
    imageUrls: [],
    videoUrl: null,
    shippingInfo: 'CJ대한통운',
    shippingFee: 3000,
    isLiked: false,
  ),
  Product(
    id: '16',
    productName: '[쏜리서치] 비타민D 5000IU',
    descImageUrl: '',
    category: '운동보조제',
    categoryDetail: '비타민',
    price: 20000,
    discountPrice: 15500,
    mainImageUrl: '',
    imageUrls: [],
    videoUrl: null,
    shippingInfo: 'CJ대한통운',
    shippingFee: 3000,
    isLiked: false,
  ),

  // --- 운동용품
  Product(
    id: '17',
    productName: '[트라택] 튜빙밴드 세트',
    descImageUrl: '',
    category: '운동용품',
    categoryDetail: '밴드/튜빙',
    price: 18000,
    discountPrice: 14900,
    mainImageUrl: '',
    imageUrls: [],
    videoUrl: null,
    shippingInfo: 'CJ대한통운',
    shippingFee: 3000,
    isLiked: false,
  ),
  Product(
    id: '18',
    productName: '[스텝업] 저항밴드 3종',
    descImageUrl: '',
    category: '운동용품',
    categoryDetail: '밴드/튜빙',
    price: 21000,
    discountPrice: 15800,
    mainImageUrl: '',
    imageUrls: [],
    videoUrl: null,
    shippingInfo: 'CJ대한통운',
    shippingFee: 3000,
    isLiked: false,
  ),
  Product(
    id: '19',
    productName: '[슬리피스] EVA 폼롤러',
    descImageUrl: '',
    category: '운동용품',
    categoryDetail: '폼롤러/마사지볼',
    price: 16000,
    discountPrice: 11900,
    mainImageUrl: '',
    imageUrls: [],
    videoUrl: null,
    shippingInfo: 'CJ대한통운',
    shippingFee: 3000,
    isLiked: false,
  ),
  Product(
    id: '20',
    productName: '[바디바인] 마사지볼 2p',
    descImageUrl: '',
    category: '운동용품',
    categoryDetail: '폼롤러/마사지볼',
    price: 9800,
    discountPrice: 7500,
    mainImageUrl: '',
    imageUrls: [],
    videoUrl: null,
    shippingInfo: 'CJ대한통운',
    shippingFee: 3000,
    isLiked: false,
  ),
  Product(
    id: '21',
    productName: '[나이키] 요가매트 6mm',
    descImageUrl: '',
    category: '운동용품',
    categoryDetail: '요가매트',
    price: 32000,
    discountPrice: 24500,
    mainImageUrl: '',
    imageUrls: [],
    videoUrl: null,
    shippingInfo: 'CJ대한통운',
    shippingFee: 3000,
    isLiked: false,
  ),
  Product(
    id: '22',
    productName: '[아디다스] TPE 요가매트',
    descImageUrl: '',
    category: '운동용품',
    categoryDetail: '요가매트',
    price: 27000,
    discountPrice: 20900,
    mainImageUrl: '',
    imageUrls: [],
    videoUrl: null,
    shippingInfo: 'CJ대한통운',
    shippingFee: 3000,
    isLiked: false,
  ),

  // --- 헬스웨어
  Product(
    id: '23',
    productName: '[언더아머] UA 트레이닝 반팔',
    descImageUrl: '',
    category: '헬스웨어',
    categoryDetail: '운동복',
    price: 35000,
    discountPrice: 27000,
    mainImageUrl: '',
    imageUrls: [],
    videoUrl: null,
    shippingInfo: 'CJ대한통운',
    shippingFee: 3000,
    isLiked: false,
  ),
  Product(
    id: '24',
    productName: '[나이키] 플렉스 쇼츠',
    descImageUrl: '',
    category: '헬스웨어',
    categoryDetail: '운동복',
    price: 42000,
    discountPrice: 33500,
    mainImageUrl: '',
    imageUrls: [],
    videoUrl: null,
    shippingInfo: 'CJ대한통운',
    shippingFee: 3000,
    isLiked: false,
  ),
  Product(
    id: '25',
    productName: '[안다르] 에어코튼 스포츠브라',
    descImageUrl: '',
    category: '헬스웨어',
    categoryDetail: '스포츠브라/언더웨어',
    price: 29000,
    discountPrice: 21900,
    mainImageUrl: '',
    imageUrls: [],
    videoUrl: null,
    shippingInfo: 'CJ대한통운',
    shippingFee: 3000,
    isLiked: false,
  ),
  Product(
    id: '26',
    productName: '[젝시믹스] 뉴핏 스포츠브라',
    descImageUrl: '',
    category: '헬스웨어',
    categoryDetail: '스포츠브라/언더웨어',
    price: 32000,
    discountPrice: 24000,
    mainImageUrl: '',
    imageUrls: [],
    videoUrl: null,
    shippingInfo: 'CJ대한통운',
    shippingFee: 3000,
    isLiked: false,
  ),
  Product(
    id: '27',
    productName: '[아식스] 젤-카야노 29',
    descImageUrl: '',
    category: '헬스웨어',
    categoryDetail: '운동화',
    price: 145000,
    discountPrice: 116000,
    mainImageUrl: '',
    imageUrls: [],
    videoUrl: null,
    shippingInfo: 'CJ대한통운',
    shippingFee: 3000,
    isLiked: false,
  ),
  Product(
    id: '28',
    productName: '[나이키] 에어맥스 인피니티',
    descImageUrl: '',
    category: '헬스웨어',
    categoryDetail: '운동화',
    price: 129000,
    discountPrice: 102000,
    mainImageUrl: '',
    imageUrls: [],
    videoUrl: null,
    shippingInfo: 'CJ대한통운',
    shippingFee: 3000,
    isLiked: false,
  ),
  Product(
    id: '29',
    productName: '[나이키] 러닝캡',
    descImageUrl: '',
    category: '헬스웨어',
    categoryDetail: '모자',
    price: 25000,
    discountPrice: 19900,
    mainImageUrl: '',
    imageUrls: [],
    videoUrl: null,
    shippingInfo: 'CJ대한통운',
    shippingFee: 3000,
    isLiked: false,
  ),
  Product(
    id: '30',
    productName: '[아디다스] 클럽 캡',
    descImageUrl: '',
    category: '헬스웨어',
    categoryDetail: '모자',
    price: 19000,
    discountPrice: 14500,
    mainImageUrl: '',
    imageUrls: [],
    videoUrl: null,
    shippingInfo: 'CJ대한통운',
    shippingFee: 3000,
    isLiked: false,
  ),
  Product(
    id: '31',
    productName: '[언더아머] 컴프레션 레깅스',
    descImageUrl: '',
    category: '헬스웨어',
    categoryDetail: '압박웨어/테이핑',
    price: 54000,
    discountPrice: 41900,
    mainImageUrl: '',
    imageUrls: [],
    videoUrl: null,
    shippingInfo: 'CJ대한통운',
    shippingFee: 3000,
    isLiked: false,
  ),
  Product(
    id: '32',
    productName: '[젝시믹스] 테이핑 밴드',
    descImageUrl: '',
    category: '헬스웨어',
    categoryDetail: '압박웨어/테이핑',
    price: 13000,
    discountPrice: 9900,
    mainImageUrl: '',
    imageUrls: [],
    videoUrl: null,
    shippingInfo: 'CJ대한통운',
    shippingFee: 3000,
    isLiked: false,
  ),

  // --- 서비스
  Product(
    id: '33',
    productName: '[휘트니스랩] 1:1 PT 10회권',
    descImageUrl: '',
    category: '서비스',
    categoryDetail: 'PT/운동 클래스',
    price: 600000,
    discountPrice: 480000,
    mainImageUrl: '',
    imageUrls: [],
    videoUrl: null,
    shippingInfo: 'CJ대한통운',
    shippingFee: 0,
    isLiked: false,
  ),
  Product(
    id: '34',
    productName: '[바디핏] 그룹 운동 클래스 8회',
    descImageUrl: '',
    category: '서비스',
    categoryDetail: 'PT/운동 클래스',
    price: 240000,
    discountPrice: 180000,
    mainImageUrl: '',
    imageUrls: [],
    videoUrl: null,
    shippingInfo: 'CJ대한통운',
    shippingFee: 0,
    isLiked: false,
  ),
];

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  String selectedCategory = '식품';
  String selectedCategoryDetail = '전체';
  bool isGridView = true;

  // 장바구니 상태
  List<CartItem> cartItems = [];

  // 장바구니에 상품 추가 로직
  void _addToCart(Product product) {
    setState(() {
      final idx = cartItems.indexWhere((item) => item.product.id == product.id);
      if (idx >= 0) {
        cartItems[idx].quantity++;
      } else {
        cartItems.add(CartItem(product: product));
      }
    });
  }

  Future<void> goToRegisterPage() async {
    // (변경!) 마지막 id 넘겨서 새 상품에 id+1 부여
    int lastId = allProducts.isNotEmpty ? int.parse(allProducts.last.id) : 0;

    final Product? newProduct = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProductRegisterPage(lastId: lastId)),
    );
    if (newProduct != null) {
      setState(() => allProducts.add(newProduct));
    }
  }

  // 장바구니 화면으로 이동 로직
  void goToCartPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CartPage(cartItems: cartItems)),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Product> filteredProducts = allProducts.where((product) {
      if (selectedCategoryDetail == '전체') {
        return product.category == selectedCategory;
      }
      return product.category == selectedCategory &&
          product.categoryDetail == selectedCategoryDetail;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Stack(
          alignment: Alignment.center,
          children: [
            const Text('상품 목록'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: goToRegisterPage,
                  child: const Text(
                    '상품 등록',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                IconButton(
                  onPressed: goToCartPage,
                  icon: const Icon(Icons.shopping_cart_outlined),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          CategorySelector(
            selectedCategory: selectedCategory,
            selectedCategoryDetail: selectedCategoryDetail,
            onCategorySelected: (category) {
              setState(() {
                selectedCategory = category;
                selectedCategoryDetail = '전체';
              });
            },
            onCategoryDetailSelected: (detail) {
              setState(() {
                selectedCategoryDetail = detail;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('총 ${filteredProducts.length}개'),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => setState(() => isGridView = false),
                      icon: Icon(
                        Icons.view_list,
                        color: isGridView ? Colors.grey : Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => isGridView = true),
                      icon: Icon(
                        Icons.grid_view,
                        color: isGridView ? Colors.black : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: isGridView
                ? GridView.count(
                    padding: const EdgeInsets.all(12),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.65,
                    children: filteredProducts
                        .map(
                          (product) => ProductItem(
                            product: product,
                            onAddToCart: _addToCart,
                          ),
                        )
                        .toList(),
                  )
                : ListView.builder(
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return ProductItem(
                        product: product,
                        onAddToCart: _addToCart,

                        isRow: true,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
