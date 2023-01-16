import 'package:ezpark/features/spots/new_spot/data/repositories/spot_repository_impl.dart';
import 'package:ezpark/features/spots/new_spot/domain/entities/add_spot.dart';
import 'package:ezpark/features/spots/new_spot/domain/repositories/spot_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/response/entities/response_result.dart';

class AddSpotFormNotifier extends StateNotifier<AsyncValue<ResponseResult>> {
  AddSpotFormNotifier({required SpotRepository spotRepository})
      : _spotRepository = spotRepository,
        super(
          AsyncValue<ResponseResult>.data(
            ResponseResult.empty(),
          ),
        );

  final SpotRepository _spotRepository;

  Future<void> addSpot(AddSpot newSpot) async {
    state = const AsyncValue.loading();
    final result = await _spotRepository.addSpot(newSpot);
    state = AsyncValue<ResponseResult>.data(result);
  }
}

final spotNotiferProvider =
    StateNotifierProvider<AddSpotFormNotifier, AsyncValue<ResponseResult>>(
  (ref) {
    final spotRepository = ref.read(spotRepositoryProvider);
    return AddSpotFormNotifier(spotRepository: spotRepository);
  },
);
