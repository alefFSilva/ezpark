import 'package:flutter/widgets.dart';

@immutable
class ResponseResult {
  const ResponseResult({
    required this.success,
    this.errorMessage,
  });
  final bool success;
  final String? errorMessage;

  factory ResponseResult.empty() => const ResponseResult(success: false);

  factory ResponseResult.onError({
    required String errorMessage,
  }) =>
      ResponseResult(
        success: false,
        errorMessage: errorMessage,
      );
  factory ResponseResult.onSuccess() => const ResponseResult(
        success: true,
      );
}
