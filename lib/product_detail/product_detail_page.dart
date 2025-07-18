import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  final bool showBottomBar; // true: 하단 결제 바 있는 화면

  const ProductDetailPage({super.key, this.showBottomBar = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('홈페이지 제목'),
        centerTitle: true,
        leading: const BackButton(),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 이미지 영역
          Container(
            height: 250,
            color: Colors.grey[300],
            alignment: Alignment.center,
            child: const Text('상품 이미지'),
          ),
          const SizedBox(height: 16),

          // 상품 제목 및 가격
          const Text(
            '부드러운 닭가슴살 12팩',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            '29,000원 → 25,000원 (-66%)',
            style: TextStyle(
              fontSize: 16,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // 배송 정보 입력
          const TextField(
            decoration: InputDecoration(
              labelText: '배송 받을 이름',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          const TextField(
            decoration: InputDecoration(
              labelText: '배송지',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // 상품 설명
          const TextField(
            maxLines: 4,
            decoration: InputDecoration(
              labelText: '상품 설명/요청사항',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // 후기
          const Text('후기'),
          const SizedBox(height: 8),
          reviewBox('좋아요'),
          const SizedBox(height: 8),
          reviewBox('맛이 부드럽고 양도 넉넉해요'),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {},
            child: const Text('리뷰 더보기 >', style: TextStyle(color: Colors.blue)),
          ),
          const SizedBox(height: 80), // Bottom bar 공간 확보
        ],
      ),

      // 하단 바
      bottomNavigationBar: showBottomBar
          ? bottomBarWithPrice(context)
          : basicBottomBar(context),
    );
  }

  // 기본 하단 바
  Widget basicBottomBar(BuildContext context) {
    return BottomAppBar(
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.favorite_border),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () {},
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('구매하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 결제 정보가 포함된 하단 바
  Widget bottomBarWithPrice(BuildContext context) {
    return BottomAppBar(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // 미리보기 이미지
                Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text('부드러운 닭가슴살 12팩', style: TextStyle(fontSize: 14)),
                ),
                const Text(
                  '50,000원',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  onPressed: () {},
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('구매하기'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // 리뷰 박스 위젯
  static Widget reviewBox(String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(content),
    );
  }
}
