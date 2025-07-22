import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thunder_shop/model/product.dart';
import 'package:thunder_shop/product_detail/product_detail_page.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ProductRegisterPage extends StatefulWidget {
  final int lastId;
  const ProductRegisterPage({super.key, required this.lastId});

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
  String? _videoThumbnailPath;
  List<String> _imageUrls = [];
  bool _isPicking = false;
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
    _priceController.addListener(_onPriceOrDiscountChanged);
    _discountPriceController.addListener(_onPriceOrDiscountChanged);
  }

  void _onPriceOrDiscountChanged() {
    final price = int.tryParse(_priceController.text) ?? 0;
    final discount = int.tryParse(_discountPriceController.text) ?? 0;
    if (price > 0 && discount > 0 && discount < price) {
      setState(() {
        _discountPercent = 100 * (price - discount) / price;
      });
    } else {
      setState(() {
        _discountPercent = null;
      });
    }
    if (_priceController.text.isEmpty) {
      if (_discountPriceController.text.isNotEmpty) {
        _discountPriceController.clear();
      }
    } else if (discount >= price && _discountPriceController.text.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('할인된 가격을 입력해주세요.')));
        _discountPriceController.clear();
      });
    }
  }

  Widget buildDeleteButton(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)],
        ),
        child: Icon(Icons.close, size: 18, color: Colors.grey[700]),
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
          _videoThumbnailPath = null;
        });
        final String? thumb = await VideoThumbnail.thumbnailFile(
          video: video.path,
          imageFormat: ImageFormat.PNG,
          maxWidth: 180,
          quality: 75,
        );
        if (thumb != null) {
          setState(() => _videoThumbnailPath = thumb);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('동영상 선택 중 오류가 발생했습니다: $e')));
    } finally {
      _isPicking = false;
    }
  }

  void _registerProduct() async {
    if (_formKey.currentState?.validate() != true) return;
    if (_mainImageUrl == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('대표 이미지를 등록해 주세요!')));
      return;
    }
    // 상품 설명 이미지 필수 검증 제거 (descImageUrl)
    if (_selectedCategory == null || _selectedSubCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('카테고리를 선택해 주세요!')));
      return;
    }
    if (_shippingInfoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('배송 정보를 입력해 주세요!')));
      return;
    }
    if (_shippingFeeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('배송비를 입력해주세요.')));
      return;
    }
    int price = int.tryParse(_priceController.text) ?? 0;
    int discountPrice = int.tryParse(_discountPriceController.text) ?? 0;
    if (_discountPriceController.text.trim().isEmpty) {
      discountPrice = price;
    }
    if (discountPrice > price) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('할인가는 판매가보다 높을 수 없습니다!')));
      return;
    }

    int shippingFee = int.tryParse(_shippingFeeController.text) ?? 0;

    final product = Product(
      id: (widget.lastId + 1).toString(),
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
      isLiked: false,
    );

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 32,
          horizontal: 24,
        ), // 위아래 여유
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center, // 수직 중앙 정렬
          children: [
            const Text(
              '상품 등록이 완료되었습니다.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 28), // 텍스트와 버튼 사이 공간
            Center(
              child: SizedBox(
                width: 90,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
        // actions 없앰 (Column에서 직접 배치)
      ),
    );

    Navigator.pop(context, product);
  }

  // --- 미리보기 기능 추가 ---
  void _previewProduct() {
    if (_productNameController.text.trim().isEmpty ||
        _mainImageUrl == null ||
        // 상품설명 이미지는 필수 항목에서 제거됨!
        _selectedCategory == null ||
        _selectedSubCategory == null ||
        _priceController.text.trim().isEmpty ||
        _shippingInfoController.text.trim().isEmpty ||
        _shippingFeeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('미리보기를 위해 필수 항목(*)을 모두 입력해주세요!')),
      );
      return;
    }

    final price = int.tryParse(_priceController.text) ?? 0;
    int discountPrice = int.tryParse(_discountPriceController.text) ?? 0;
    if (_discountPriceController.text.trim().isEmpty) {
      discountPrice = price;
    }
    final shippingFee = int.tryParse(_shippingFeeController.text) ?? 0;

    final dummyProduct = Product(
      id: "preview_id", // 미리보기용 임시 ID
      productName: _productNameController.text.trim(),
      descImageUrl: _descImageUrl ?? '',
      category: _selectedCategory!,
      categoryDetail: _selectedSubCategory!,
      price: price,
      discountPrice: discountPrice,
      mainImageUrl: _mainImageUrl!,
      imageUrls: _imageUrls,
      videoUrl: _videoUrl,
      shippingInfo: _shippingInfoController.text.trim(),
      shippingFee: shippingFee,
      isLiked: false,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(
          product: dummyProduct,
          cartItems: [],
          onAddToCart: (_) {},
          isPreview: true,
        ),
      ),
    );
  }
  // --- 미리보기 기능 추가 끝 ---

  @override
  void dispose() {
    _priceController.removeListener(_onPriceOrDiscountChanged);
    _discountPriceController.removeListener(_onPriceOrDiscountChanged);
    _productNameController.dispose();
    _priceController.dispose();
    _discountPriceController.dispose();
    _shippingFeeController.dispose();
    _shippingInfoController.dispose();
    super.dispose();
  }

  InputDecoration inputStyle(String hint, BorderRadius borderRadius) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(borderRadius: borderRadius),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black),
        borderRadius: borderRadius,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mainBlue = const Color(0xFF279AF1);
    final borderRadius = BorderRadius.circular(14);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '상품 등록',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFB3E5FC), // 연하늘색
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  children: [
                    // 대표 이미지
                    const Text(
                      '대표 이미지 *',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    _mainImageUrl == null
                        ? InkWell(
                            onTap: _pickMainImage,
                            borderRadius: borderRadius,
                            child: Container(
                              height: 140,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: borderRadius,
                                border: Border.all(color: mainBlue, width: 2),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.add_a_photo_rounded,
                                  color: Colors.blue,
                                  size: 36,
                                ),
                              ),
                            ),
                          )
                        : Stack(
                            children: [
                              ClipRRect(
                                borderRadius: borderRadius,
                                child: Image.file(
                                  File(_mainImageUrl!),
                                  width: double.infinity,
                                  height: 140,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: buildDeleteButton(() {
                                  setState(() => _mainImageUrl = null);
                                }),
                              ),
                            ],
                          ),
                    const SizedBox(height: 24),
                    // 추가 이미지
                    const Text(
                      '추가 이미지 (최대 9장)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _imageUrls.length + 1,
                        itemBuilder: (context, index) {
                          if (index == _imageUrls.length) {
                            if (_imageUrls.length < 9) {
                              return InkWell(
                                onTap: _pickAdditionalImages,
                                borderRadius: borderRadius,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: borderRadius,
                                    border: Border.all(
                                      color: mainBlue,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.add_a_photo_rounded,
                                      color: Colors.blue,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          }
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: borderRadius,
                                  child: Image.file(
                                    File(_imageUrls[index]),
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: buildDeleteButton(() {
                                    setState(() {
                                      _imageUrls.removeAt(index);
                                    });
                                  }),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    // 동영상
                    const Text(
                      '동영상',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    _videoUrl == null
                        ? InkWell(
                            onTap: _pickVideo,
                            borderRadius: borderRadius,
                            child: Container(
                              height: 140,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: borderRadius,
                                border: Border.all(color: mainBlue, width: 2),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.video_collection_rounded,
                                  color: Colors.blue,
                                  size: 36,
                                ),
                              ),
                            ),
                          )
                        : Stack(
                            children: [
                              ClipRRect(
                                borderRadius: borderRadius,
                                child: _videoThumbnailPath != null
                                    ? Image.file(
                                        File(_videoThumbnailPath!),
                                        width: double.infinity,
                                        height: 140,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        width: double.infinity,
                                        height: 140,
                                        color: Colors.black,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: mainBlue,
                                          ),
                                        ),
                                      ),
                              ),
                              const Positioned.fill(
                                child: Icon(
                                  Icons.play_circle_fill,
                                  color: Colors.white70,
                                  size: 60,
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: buildDeleteButton(() {
                                  setState(() {
                                    _videoUrl = null;
                                    _videoThumbnailPath = null;
                                  });
                                }),
                              ),
                            ],
                          ),
                    const SizedBox(height: 24),
                    // 상품 설명 이미지 (필수 아님)
                    const Text(
                      '상품 설명 이미지',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    _descImageUrl == null
                        ? InkWell(
                            onTap: _pickDescImage,
                            borderRadius: borderRadius,
                            child: Container(
                              height: 140,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: borderRadius,
                                border: Border.all(color: mainBlue, width: 2),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.description_rounded,
                                  color: Colors.blue,
                                  size: 36,
                                ),
                              ),
                            ),
                          )
                        : Stack(
                            children: [
                              ClipRRect(
                                borderRadius: borderRadius,
                                child: Image.file(
                                  File(_descImageUrl!),
                                  width: double.infinity,
                                  height: 140,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: buildDeleteButton(() {
                                  setState(() => _descImageUrl = null);
                                }),
                              ),
                            ],
                          ),
                    const SizedBox(height: 24),
                    // 상품명
                    const Text(
                      '상품명 *',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _productNameController,
                      decoration: inputStyle('상품명을 입력해주세요.', borderRadius),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return '상품명을 입력해주세요.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    // 카테고리
                    const Text(
                      '카테고리 *',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: inputStyle('카테고리를 선택하세요', borderRadius),
                      // 연하늘색 드롭다운 배경!
                      dropdownColor: const Color.fromARGB(255, 230, 247, 255),
                      items: _categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCategory = newValue;
                          _selectedSubCategory = null;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return '카테고리를 선택해주세요.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedSubCategory,
                      decoration: inputStyle('세부 카테고리를 선택하세요', borderRadius),
                      // 연하늘색 드롭다운 배경!
                      dropdownColor: const Color.fromARGB(255, 230, 247, 255),
                      items: _selectedCategory == null
                          ? []
                          : _subCategories[_selectedCategory!]!.map((
                              String subCategory,
                            ) {
                              return DropdownMenuItem<String>(
                                value: subCategory,
                                child: Text(subCategory),
                              );
                            }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedSubCategory = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return '세부 카테고리를 선택해주세요.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    // 가격 정보
                    const Text(
                      '가격 정보 *',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // 판매가
                        Expanded(
                          child: TextFormField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            decoration: inputStyle('판매가', borderRadius),
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  int.tryParse(value) == null ||
                                  int.parse(value) <= 0) {
                                return '유효한 판매가를 입력해주세요.';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text('원', style: TextStyle(color: Colors.grey)),
                        const SizedBox(width: 16),
                        // 할인가 + %
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _discountPriceController,
                                  keyboardType: TextInputType.number,
                                  decoration: inputStyle(
                                    '할인가 (선택 사항)',
                                    borderRadius,
                                  ),
                                  validator: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      if (int.tryParse(value) == null ||
                                          int.parse(value) < 0) {
                                        return '유효한 할인 가격을 입력해주세요.';
                                      }
                                      final originalPrice =
                                          int.tryParse(_priceController.text) ??
                                          0;
                                      final discountPrice =
                                          int.tryParse(value) ?? 0;
                                      if (discountPrice >= originalPrice &&
                                          originalPrice != 0) {
                                        return '할인가는 판매가보다 작아야 합니다.';
                                      }
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                '원',
                                style: TextStyle(color: Colors.grey),
                              ),
                              if (_discountPercent != null) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red[50],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '-${_discountPercent!.toStringAsFixed(0)}%',
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // 배송 정보 (1줄 입력)
                    const Text(
                      '배송 정보 *',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _shippingInfoController,
                      maxLines: 1, // 1줄
                      decoration: inputStyle('배송 정보를 입력해주세요.', borderRadius),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return '배송 정보를 입력해주세요.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    // 배송비
                    const Text(
                      '배송비 *',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _shippingFeeController,
                      keyboardType: TextInputType.number,
                      decoration: inputStyle(
                        '배송비를 입력해주세요 (무료 배송시 0 입력)',
                        borderRadius,
                      ).copyWith(suffixText: '원'),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            int.tryParse(value) == null ||
                            int.parse(value) < 0) {
                          return '유효한 배송비를 입력해주세요.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _previewProduct,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: mainBlue,
                    side: BorderSide(color: mainBlue, width: 1.6),
                    shape: RoundedRectangleBorder(borderRadius: borderRadius),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    '미리보기',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: ElevatedButton(
                  onPressed: _registerProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainBlue,
                    shape: RoundedRectangleBorder(borderRadius: borderRadius),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    '등록하기',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ), // 흰색
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
