import 'package:flutter/material.dart';

class FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onToggle;
  final double size; // 하트 크기
  final Color activeColor; // 찜한 상태일 때 색
  final Color inactiveColor; // 찜하지 않은 상태일 때 색

  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onToggle,
    required this.size,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onToggle,
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? activeColor : inactiveColor,
        size: size,
      ),
    );
  }
}
