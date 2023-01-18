import 'package:ezpark/core/network/response/entities/response_result.dart';
import 'package:ezpark/features/spots/data/repositories/spot_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/spots_count.dart';

final spotsCounterProvider = FutureProvider<ResponseResult<SpotsCount>>(
  (ref) async {
    final spotRepository = ref.read(spotRepositoryProvider);
    return await spotRepository.getSpotsCounter();
  },
);
