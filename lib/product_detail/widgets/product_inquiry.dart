import 'package:flutter/material.dart';
import '../../style/common_colors.dart';

class ProductInquiry extends StatefulWidget {
  final bool showForm;

  const ProductInquiry({super.key, this.showForm = true});

  @override
  State<ProductInquiry> createState() => _ProductInquiryState();
}

class _ProductInquiryState extends State<ProductInquiry> {
  final List<Map<String, String>> _inquiries = [];
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  void _submitInquiry() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('제목과 내용을 모두 입력해주세요.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _inquiries.add({'title': title, 'content': content});
      _titleController.clear();
      _contentController.clear();
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('문의가 등록되었습니다.')));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ..._inquiries.map(
          (inquiry) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    inquiry['title']!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(inquiry['content']!),
                ),
              ],
            ),
          ),
        ),
        if (widget.showForm) ...[
          const SizedBox(height: 8),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: '제목',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _contentController,
            decoration: const InputDecoration(
              labelText: '문의 내용',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: _submitInquiry,
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
