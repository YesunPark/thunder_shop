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
              return Image.file(
                File(path),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image),
                  );
                },
              );
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
