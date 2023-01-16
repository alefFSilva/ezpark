import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'entities/response_result.dart';

class ResponseResultNotifier extends StateNotifier<ResponseResult> {
  ResponseResultNotifier() : super(ResponseResult.empty());

  bool get sucess => state.success;
  String? get errorMessage => state.errorMessage;
  // dynamic get data => state.data;

  void setState(ResponseResult responseResult) => state = state;
}
