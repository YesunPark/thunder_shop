// 카테고리 관리

import 'package:flutter/material.dart';

class CategorySelector extends StatelessWidget {
  final String selectedCategory;
  final String selectedSubCategory;
  final Function(String) onCategorySelected;
  final Function(String) onSubCategorySelected;

  CategorySelector({
    required this.selectedCategory,
    required this.selectedSubCategory,
    required this.onCategorySelected,
    required this.onSubCategorySelected,
    super.key,
  });

  final Map<String, List<String>> categoryMap = {
    '식품': ['전체', '닭가슴살', '프로틴', '에너지드링크', '샐러드'],
    '운동보조제': ['전체', '크레아틴', 'BCAA/아미노산', '프리워크아웃', '비타민'],
    '운동용품': ['전체', '밴드/튜빙', '폼롤러/마사지볼', '요가매트'],
    '헬스웨어': ['전체', '운동복', '스포츠브라/언더웨어', '운동화', '모자', '압박웨어/테이핑'],
    '서비스': ['전체', 'PT/운동 클래스'],
  };

  Widget buildCategoryBox(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          border: selected ? Border.all(color: Colors.black) : null,
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Text(label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final subCategories = categoryMap[selectedCategory]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          children: categoryMap.keys.map((cat) {
            return buildCategoryBox(
              cat,
              cat == selectedCategory,
              () => onCategorySelected(cat),
            );
          }).toList(),
        ),
        Wrap(
          children: subCategories.map((sub) {
            return buildCategoryBox(
              sub,
              sub == selectedSubCategory,
              () => onSubCategorySelected(sub),
            );
          }).toList(),
        ),
      ],
    );
  }
}
