import 'package:ezpark/core/network/response/response_result_%20notifer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'entities/response_result.dart';

final responseResultProvider =
    StateNotifierProvider.autoDispose<ResponseResultNotifier, ResponseResult>(
  (ref) {
    return ResponseResultNotifier();
  },
);
