import 'dart:io';
import 'package:flutter/material.dart';

class ProductImageSlider extends StatelessWidget {
  final List<String> imageList;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;

  const ProductImageSlider({
    super.key,
    required this.imageList,
    required this.currentIndex,
    required this.onPageChanged,
  });

  // 이미지 타입별 자동 분기
  Widget buildImage(String path) {
    if (path.startsWith('http')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey[300],
          alignment: Alignment.center,
          child: const Icon(Icons.broken_image),
        ),
      );
    } else if (path.startsWith('/')) {
      // 로컬 파일
      return Image.file(
        File(path),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey[300],
          alignment: Alignment.center,
          child: const Icon(Icons.broken_image),
        ),
      );
    } else {
      // assets
      return Image.asset(
        path,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey[300],
          alignment: Alignment.center,
          child: const Icon(Icons.broken_image),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 250,
          child: PageView.builder(
            itemCount: imageList.length,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              final path = imageList[index];
              // **자동 분기 함수 사용!**
              return buildImage(path);
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(imageList.length, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentIndex == index ? Colors.black : Colors.grey[300],
              ),
            );
          }),
        ),
      ],
    );
  }
}
