import 'package:intl/intl.dart';

/// 3자리마다 콤마를 붙여주는 숫자 포매팅 함수
String formatWithComma(num number) {
  final formatter = NumberFormat('#,###');
  return formatter.format(number);
}
