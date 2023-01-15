import 'package:flutter_riverpod/flutter_riverpod.dart';

final initializerProvider = FutureProvider<void>(
  ((ref) async {
    await Future.delayed(
      const Duration(seconds: 6),
    );
  }),
);
