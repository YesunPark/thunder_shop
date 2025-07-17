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
  final TextEditingController _shippingInfoController = TextEditingController();

  String? _selectedCategory;
  String? _selectedSubCategory;
  String? _mainImageUrl;
  String? _descImageUrl;
  String? _videoUrl;
  List<String> _imageUrls = [];

  bool _isPicking = false;

  // 할인율 표시용 변수
  double? _discountPercent;

  final List<String> _categories = ['식품', '운동보조제', '운동용품', '헬스웨어', '서비스'];
  final Map<String, List<String>> _subCategories = {
    '식품': ['닭가슴살', '프로틴', '에너지드링크', '샐러드'],
    '운동보조제': ['크레아틴', 'BCAA/아미노산', '프리워크아웃', '비타민'],
    '운동용품': ['밴드/튜빙', '폼롤러/마사지볼', '요가매트'],
    '헬스웨어': ['운동복', '스포츠브라/언더웨어', '운동화', '모자', '압박웨어/테이핑'],
    '서비스': ['PT/운동 클래스'],
  };

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // 실시간으로 할인율, 할인가 로직 체크
    _priceController.addListener(_onPriceOrDiscountChanged);
    _discountPriceController.addListener(_onPriceOrDiscountChanged);
  }

  void _onPriceOrDiscountChanged() {
    final price = int.tryParse(_priceController.text) ?? 0;
    final discount = int.tryParse(_discountPriceController.text) ?? 0;

    // 할인율 계산
    if (price > 0 && discount > 0 && discount < price) {
      setState(() {
        _discountPercent = 100 * (price - discount) / price;
      });
    } else {
      setState(() {
        _discountPercent = null;
      });
    }

    // 할인가 입력제한
    if (_priceController.text.isEmpty) {
      // 판매가가 없으면 할인가 입력 불가 및 초기화
      if (_discountPriceController.text.isNotEmpty) {
        _discountPriceController.clear();
      }
    } else if (discount >= price && _discountPriceController.text.isNotEmpty) {
      // 할인가가 판매가보다 크거나 같으면 에러 & 초기화
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('할인된 가격을 입력해주세요.')));
        _discountPriceController.clear();
      });
    }
  }

  Widget buildDeleteButton(VoidCallback onTap) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey[400]!, width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Center(
        child: Icon(Icons.close_rounded, color: Colors.grey[700], size: 18),
      ),
    );
  }

  Future<void> _pickMainImage() async {
    if (_isPicking) return;
    _isPicking = true;
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _mainImageUrl = image.path;
        });
      }
    } finally {
      _isPicking = false;
    }
  }

  Future<void> _pickDescImage() async {
    if (_isPicking) return;
    _isPicking = true;
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _descImageUrl = image.path;
        });
      }
    } finally {
      _isPicking = false;
    }
  }

  Future<void> _pickAdditionalImages() async {
    if (_isPicking) return;
    _isPicking = true;
    try {
      final List<XFile>? images = await _picker.pickMultiImage();
      if (images != null && images.isNotEmpty) {
        setState(() {
          _imageUrls.addAll(images.map((xfile) => xfile.path));
          if (_imageUrls.length > 9) {
            _imageUrls = _imageUrls.sublist(0, 9);
          }
        });
      }
    } finally {
      _isPicking = false;
    }
  }

  Future<void> _pickVideo() async {
    if (_isPicking) return;
    _isPicking = true;
    try {
      final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        setState(() {
          _videoUrl = video.path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('동영상 선택 중 오류가 발생했습니다: $e')));
    } finally {
      _isPicking = false;
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
    if (_descImageUrl == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('상품설명 이미지를 등록해 주세요!')));
      return;
    }
    if (_selectedCategory == null || _selectedSubCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('카테고리를 선택해 주세요!')));
      return;
    }
    if (_shippingInfoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('배송 정보를 입력해 주세요!')));
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
    int shippingFee = int.tryParse(_shippingFeeController.text) ?? 0;

    final product = Product(
      id: UniqueKey().toString(),
      productName: _productNameController.text.trim(),
      descImageUrl: _descImageUrl ?? '',
      category: _selectedCategory!,
      categoryDetail: _selectedSubCategory!,
      price: price,
      discountPrice: discountPrice,
      mainImageUrl: _mainImageUrl ?? '',
      imageUrls: _imageUrls,
      videoUrl: _videoUrl,
      shippingInfo: _shippingInfoController.text.trim(),
      shippingFee: shippingFee,
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('상품 미리보기'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('상품명: ${product.productName}'),
              Text('설명 이미지: ${product.descImageUrl}'),
              Text('카테고리: ${product.category} / ${product.categoryDetail}'),
              Text('가격: ${product.price}원 (할인: ${product.discountPrice}원)'),
              Text('대표 이미지: ${product.mainImageUrl}'),
              Text('추가 이미지: ${product.imageUrls.length}장'),
              if (product.videoUrl != null) Text('동영상: ${product.videoUrl}'),
              Text(
                '배송정보: ${product.shippingInfo} (배송비: ${product.shippingFee}원)',
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _priceController.removeListener(_onPriceOrDiscountChanged);
    _discountPriceController.removeListener(_onPriceOrDiscountChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final priceValue = int.tryParse(_priceController.text) ?? 0;

    return Scaffold(
      appBar: AppBar(title: Text('상품 등록')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 1. 대표 이미지 등록
            Text('대표 이미지*'),
            _mainImageUrl == null
                ? ElevatedButton.icon(
                    icon: Icon(Icons.add_photo_alternate),
                    label: Text('이미지 선택'),
                    onPressed: _pickMainImage,
                  )
                : Stack(
                    children: [
                      Image.file(
                        File(_mainImageUrl!),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _mainImageUrl = null;
                            });
                          },
                          child: buildDeleteButton(() {
                            setState(() {
                              _mainImageUrl = null;
                            });
                          }),
                        ),
                      ),
                    ],
                  ),
            SizedBox(height: 16),

            // 2. 추가 이미지 등록(여러장)
            Text('추가 이미지 (${_imageUrls.length}/9)'),
            Wrap(
              spacing: 8,
              children: [
                ..._imageUrls.map(
                  (path) => Stack(
                    children: [
                      Image.file(
                        File(path),
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _imageUrls.remove(path);
                            });
                          },
                          child: buildDeleteButton(() {
                            setState(() {
                              _imageUrls.remove(path);
                            });
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_imageUrls.length < 9)
                  IconButton(
                    icon: Icon(Icons.add_box),
                    onPressed: _pickAdditionalImages,
                  ),
              ],
            ),
            SizedBox(height: 16),

            // 3. 동영상 등록(선택)
            Text('동영상(선택)'),
            _videoUrl == null
                ? ElevatedButton.icon(
                    icon: Icon(Icons.video_library),
                    label: Text('동영상 선택'),
                    onPressed: _pickVideo,
                  )
                : Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 60,
                        color: Colors.black12,
                        child: Center(child: Icon(Icons.videocam, size: 40)),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _videoUrl = null;
                            });
                          },
                          child: buildDeleteButton(() {
                            setState(() {
                              _videoUrl = null;
                            });
                          }),
                        ),
                      ),
                    ],
                  ),
            SizedBox(height: 16),

            // 4. 상품설명 이미지 (한 장)
            Text('상품설명 이미지*'),
            _descImageUrl == null
                ? ElevatedButton.icon(
                    icon: Icon(Icons.add_photo_alternate),
                    label: Text('설명 이미지 선택'),
                    onPressed: _pickDescImage,
                  )
                : Stack(
                    children: [
                      Image.file(
                        File(_descImageUrl!),
                        width: 120,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _descImageUrl = null;
                            });
                          },
                          child: buildDeleteButton(() {
                            setState(() {
                              _descImageUrl = null;
                            });
                          }),
                        ),
                      ),
                    ],
                  ),
            SizedBox(height: 16),

            // 5. 카테고리/소분류
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

            // 6. 상품명
            TextFormField(
              controller: _productNameController,
              decoration: InputDecoration(
                labelText: '상품명*',
                border: OutlineInputBorder(),
              ),
              validator: (v) => v == null || v.isEmpty ? '상품명을 입력해 주세요.' : null,
            ),
            SizedBox(height: 16),

            // 7. 가격/할인가
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
                    enabled: _priceController.text.isNotEmpty, // 판매가 입력 전엔 비활성화
                  ),
                ),
              ],
            ),

            // 할인율
            if (_discountPercent != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  '-${_discountPercent!.toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

            SizedBox(height: 16),

            // 8. 배송 정보
            TextFormField(
              controller: _shippingInfoController,
              decoration: InputDecoration(
                labelText: '배송정보* (택배사명 등)',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? '배송 정보를 입력해 주세요.' : null,
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
