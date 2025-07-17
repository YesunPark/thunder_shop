import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thunder_shop/model/product.dart';

class ProductRegisterPage extends StatefulWidget {
  const ProductRegisterPage({super.key});

  @override
  State<ProductRegisterPage> createState() => _ProductRegisterPageState();
}

class _ProductRegisterPageState extends State<ProductRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountPriceController =
      TextEditingController();
  final TextEditingController _shippingFeeController = TextEditingController();

  String? _selectedCategory;
  String? _selectedSubCategory;
  String? _selectedDeliveryCompany;
  String? _mainImageUrl;
  List<String> _imageUrls = [];
  String? _videoUrl;

  // 상품설명 이미지 리스트 (실제 파일 경로)
  List<XFile> _descriptionImages = [];

  final List<String> _categories = ['식품', '패션', '뷰티', '생활'];
  final Map<String, List<String>> _subCategories = {
    '식품': ['닭가슴살', '견과류', '과일'],
    '패션': ['상의', '하의', '신발'],
    '뷰티': ['스킨케어', '메이크업'],
    '생활': ['주방', '욕실'],
  };
  final List<String> _deliveryCompanies = ['CJ대한통운', '한진택배', '로젠택배'];

  final ImagePicker _picker = ImagePicker();

  // 상품설명 이미지 추가 함수
  Future<void> _pickDescriptionImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _descriptionImages.add(image);
      });
    }
  }

  void _registerProduct() {
    if (_formKey.currentState?.validate() != true) return;
    if (_mainImageUrl == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('대표 이미지를 등록해 주세요!')));
      return;
    }
    if (_selectedCategory == null || _selectedSubCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('카테고리를 선택해 주세요!')));
      return;
    }
    if (_selectedDeliveryCompany == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('택배사를 선택해 주세요!')));
      return;
    }
    if (_descriptionImages.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('상품설명 이미지를 1장 이상 추가해 주세요!')));
      return;
    }
    int price = int.tryParse(_priceController.text) ?? 0;
    int discountPrice = int.tryParse(_discountPriceController.text) ?? 0;
    if (discountPrice > price) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('할인가는 판매가보다 높을 수 없습니다!')));
      return;
    }

    final product = Product(
      id: UniqueKey().toString(),
      productName: _productNameController.text.trim(),
      description: '[이미지 ${_descriptionImages.length}장]', // 예시!
      category: '${_selectedCategory!} > ${_selectedSubCategory!}',
      price: price,
      discountPrice: discountPrice,
      imageUrl: _mainImageUrl!,
      imageUrls: _imageUrls,
      seller: "현태", // TODO: 로그인된 유저 정보로 대체
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('상품 미리보기'),
        content: Text(
          '상품명: ${product.productName}\n가격: ${product.price}원\n카테고리: ${product.category}\n설명 이미지 수: ${_descriptionImages.length}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('상품 등록')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('대표 이미지*'),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _mainImageUrl = 'https://via.placeholder.com/150';
                });
              },
              child: Text(_mainImageUrl == null ? '이미지 선택' : '이미지 변경'),
            ),
            if (_mainImageUrl != null)
              Image.network(_mainImageUrl!, width: 100, height: 100),
            SizedBox(height: 16),
            Text('추가 이미지 (0/9)'),
            Wrap(
              spacing: 8,
              children: [
                ..._imageUrls.map(
                  (url) => Stack(
                    children: [
                      Image.network(url, width: 60, height: 60),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _imageUrls.remove(url);
                            });
                          },
                          child: Icon(Icons.close, color: Colors.red, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_imageUrls.length < 9)
                  IconButton(
                    icon: Icon(Icons.add_box),
                    onPressed: () {
                      setState(() {
                        _imageUrls.add('https://via.placeholder.com/60');
                      });
                    },
                  ),
              ],
            ),
            SizedBox(height: 16),

            // 상품설명 이미지 업로드
            Text('상품설명 이미지*'),
            Wrap(
              spacing: 8,
              children: [
                ..._descriptionImages.map(
                  (file) => Stack(
                    children: [
                      Image.file(
                        File(file.path),
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _descriptionImages.remove(file);
                            });
                          },
                          child: Icon(Icons.close, color: Colors.red, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_descriptionImages.length < 10)
                  IconButton(
                    icon: Icon(Icons.add_photo_alternate),
                    onPressed: _pickDescriptionImage,
                  ),
              ],
            ),
            SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: _categories
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _selectedCategory = val;
                  _selectedSubCategory = null;
                });
              },
              decoration: InputDecoration(labelText: '대분류*'),
              validator: (v) => v == null ? '대분류를 선택해 주세요.' : null,
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedSubCategory,
              items: (_selectedCategory == null)
                  ? []
                  : _subCategories[_selectedCategory!]!
                        .map(
                          (sub) =>
                              DropdownMenuItem(value: sub, child: Text(sub)),
                        )
                        .toList(),
              onChanged: (val) {
                setState(() {
                  _selectedSubCategory = val;
                });
              },
              decoration: InputDecoration(labelText: '소분류*'),
              validator: (v) => v == null ? '소분류를 선택해 주세요.' : null,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _productNameController,
              decoration: InputDecoration(
                labelText: '상품명*',
                border: OutlineInputBorder(),
              ),
              validator: (v) => v == null || v.isEmpty ? '상품명을 입력해 주세요.' : null,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(
                      labelText: '판매가* (원)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        v == null || v.isEmpty ? '판매가를 입력해 주세요.' : null,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _discountPriceController,
                    decoration: InputDecoration(
                      labelText: '할인가 (원)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            Builder(
              builder: (context) {
                int price = int.tryParse(_priceController.text) ?? 0;
                int discount = int.tryParse(_discountPriceController.text) ?? 0;
                if (price > 0 && discount > 0 && discount < price) {
                  double percent = (100 * (price - discount) / price);
                  return Text('할인율: -${percent.toStringAsFixed(1)}%');
                }
                return SizedBox.shrink();
              },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedDeliveryCompany,
              items: _deliveryCompanies
                  .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _selectedDeliveryCompany = val;
                });
              },
              decoration: InputDecoration(labelText: '택배사*'),
              validator: (v) => v == null ? '택배사를 선택해 주세요.' : null,
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _shippingFeeController,
              decoration: InputDecoration(
                labelText: '배송비* (원)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (v) => v == null || v.isEmpty ? '배송비를 입력해 주세요.' : null,
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _registerProduct,
                  child: Text('미리보기'),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _registerProduct,
                  child: Text('등록하기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
