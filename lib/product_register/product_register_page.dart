import 'package:flutter/material.dart';

/**
 * 상품 등록 화면
 */
class ProductRegisterPage extends StatefulWidget {
  const ProductRegisterPage({Key? key}) : super(key: key);

  @override
  State<ProductRegisterPage> createState() => _ProductRegisterPageState();
}

class _ProductRegisterPageState extends State<ProductRegisterPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('상품 등록')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: const [
              // TODO: 각 입력 필드 추가
              Text('현태님 화이팅!!!!'),
            ],
          ),
        ),
      ),
    );
  }
}
