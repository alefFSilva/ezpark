import 'package:ezpark/features/spots/enums/spot_form_action.dart';
import 'package:ezpark/features/spots/providers/spots_counter_provider.dart';
import 'package:ezpark/features/spots/providers/spots_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/response/entities/response_result.dart';
import '../data/repositories/spot_repository_impl.dart';
import '../domain/entities/spot.dart';
import '../domain/repositories/spot_repository.dart';

final spotNotiferProvider =
    StateNotifierProvider<SaveSpotFormNotifier, AsyncValue<ResponseResult>>(
  ((ref) => SaveSpotFormNotifier(
        spotRepository: ref.read(spotRepositoryProvider),
        ref: ref,
      )),
);

class SaveSpotFormNotifier extends StateNotifier<AsyncValue<ResponseResult>> {
  SaveSpotFormNotifier({
    required SpotRepository spotRepository,
    required StateNotifierProviderRef ref,
  })  : _spotRepository = spotRepository,
        _ref = ref,
        super(
          AsyncValue<ResponseResult>.data(
            ResponseResult.empty(),
          ),
        );

  final SpotRepository _spotRepository;
  final StateNotifierProviderRef _ref;

  Future<void> saveSpot(
    Spot spotToSave,
    RespositoryAction spotFormAction,
  ) async {
    state = const AsyncValue.loading();

    final result = spotFormAction == RespositoryAction.add
        ? await _spotRepository.addSpot(spotToSave)
        : await _spotRepository.saveSpot(
            spotToSave: spotToSave,
          );
    _ref.invalidate(avaliableSpotsListProvider);
    _ref.invalidate(spotsCounterProvider);

    state = AsyncValue<ResponseResult<Spot>>.data(result);
  }
}
