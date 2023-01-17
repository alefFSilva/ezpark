import 'package:ezpark/features/spots/enums/spot_form_action.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/response/entities/response_result.dart';
import '../data/repositories/spot_repository_impl.dart';
import '../domain/entities/spot.dart';
import '../domain/repositories/spot_repository.dart';

final spotNotiferProvider =
    StateNotifierProvider<SaveSpotFormNotifier, AsyncValue<ResponseResult>>(
  (ref) => SaveSpotFormNotifier(
    spotRepository: ref.read(spotRepositoryProvider),
  ),
);

class SaveSpotFormNotifier extends StateNotifier<AsyncValue<ResponseResult>> {
  SaveSpotFormNotifier({
    required SpotRepository spotRepository,
  })  : _spotRepository = spotRepository,
        super(
          AsyncValue<ResponseResult>.data(
            ResponseResult.empty(),
          ),
        );

  final SpotRepository _spotRepository;

  Future<void> saveSpot(
    Spot spotToSave,
    SpotFormAction spotFormAction,
  ) async {
    state = const AsyncValue.loading();

    final result = spotFormAction == SpotFormAction.add
        ? await _spotRepository.addSpot(spotToSave)
        : await _spotRepository.saveSpot(
            spotToSave: spotToSave,
          );

    state = AsyncValue<ResponseResult<Spot>>.data(result);
  }
}
