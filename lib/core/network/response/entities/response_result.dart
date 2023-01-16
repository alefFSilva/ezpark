import 'package:flutter/widgets.dart';

@immutable
class ResponseResult<T> {
  const ResponseResult({
    required this.success,
    this.data,
    this.errorMessage,
  });
  final bool success;
  final String? errorMessage;
  final T? data;

  factory ResponseResult.empty() => const ResponseResult(success: false);

  factory ResponseResult.onError({
    required String errorMessage,
  }) =>
      ResponseResult(
        success: false,
        errorMessage: errorMessage,
      );
  factory ResponseResult.onSuccess({T? data}) => ResponseResult<T>(
        success: true,
        data: data,
      );
}
