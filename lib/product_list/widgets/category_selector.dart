import 'package:flutter/material.dart';
import 'package:thunder_shop/style/common_colors.dart'; // primary 색상을 위해 필요

class CategorySelector extends StatelessWidget {
  final String selectedCategory;
  final String selectedCategoryDetail;
  final Function(String) onCategorySelected;
  final Function(String) onCategoryDetailSelected;

  CategorySelector({
    required this.selectedCategory,
    required this.selectedCategoryDetail,
    required this.onCategorySelected,
    required this.onCategoryDetailSelected,
    super.key,
  });

  final Map<String, List<String>> categoryMap = {
    '식품': ['전체', '닭가슴살', '프로틴', '에너지드링크', '샐러드'],
    '운동보조제': ['전체', '크레아틴', 'BCAA/아미노산', '프리워크아웃', '비타민'],
    '운동용품': ['전체', '밴드/튜빙', '폼롤러/마사지볼', '요가매트'],
    '헬스웨어': ['전체', '운동복', '스포츠브라/언더웨어', '운동화', '모자', '압박웨어/테이핑'],
    '서비스': ['전체', 'PT/운동 클래스'],
  };

  @override
  Widget build(BuildContext context) {
    final categoryDetails = categoryMap[selectedCategory]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        // 상단 카테고리 탭
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: categoryMap.keys.map((cat) {
            final isSelected = cat == selectedCategory;
            return GestureDetector(
              onTap: () => onCategorySelected(cat),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    cat,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected ? Colors.black : Colors.grey,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 4),
                  Container(
                    height: 2,
                    width: 30,
                    color: isSelected ? Colors.black : Colors.transparent,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 12),
        // 하단 상세 카테고리
        SizedBox(
          height: 50,
          child: Center(
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: categoryDetails.map((detail) {
                final isSelected = detail == selectedCategoryDetail;
                return GestureDetector(
                  onTap: () => onCategoryDetailSelected(detail),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          detail,
                          style: TextStyle(
                            fontSize: 14,
                            color: isSelected
                                ? CommonColors.primary
                                : Colors.grey,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        SizedBox(height: 6),
                        Container(
                          height: 3,
                          width: isSelected ? 30 : 0,
                          color: CommonColors.primary,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
