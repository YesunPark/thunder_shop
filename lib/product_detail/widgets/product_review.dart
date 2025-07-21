import 'package:flutter/material.dart';
import '../../style/common_colors.dart';

class ProductReview extends StatefulWidget {
  final void Function(int)? onReviewCountChanged;
  final bool showForm;

  const ProductReview({
    super.key,
    this.onReviewCountChanged,
    this.showForm = true,
  });

  @override
  State<ProductReview> createState() => _ProductReviewState();
}

class _ProductReviewState extends State<ProductReview> {
  final List<Map<String, String>> _reviews = [];
  final _nicknameController = TextEditingController();
  final _contentController = TextEditingController();

  void _submitReview() {
    final nickname = _nicknameController.text.trim();
    final content = _contentController.text.trim();

    if (nickname.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('닉네임과 내용을 모두 입력해주세요.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _reviews.add({'nickname': nickname, 'content': content});
      _nicknameController.clear();
      _contentController.clear();
      widget.onReviewCountChanged?.call(_reviews.length);
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('리뷰가 등록되었습니다.')));
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ..._reviews.map(
          (review) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    review['nickname']!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(review['content']!),
                ),
              ],
            ),
          ),
        ),
        if (widget.showForm) ...[
          const SizedBox(height: 8),
          TextField(
            controller: _nicknameController,
            decoration: const InputDecoration(
              labelText: '닉네임',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _contentController,
            decoration: const InputDecoration(
              labelText: '후기 내용',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: _submitReview,
              style: ElevatedButton.styleFrom(
                backgroundColor: CommonColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('등록'),
            ),
          ),
        ],
      ],
    );
  }
}
