import 'package:ezpark/features/spots/enums/spot_form_action.dart';
import 'package:ezpark/features/spots/providers/spots_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/response/entities/response_result.dart';
import '../data/repositories/spot_repository_impl.dart';
import '../domain/entities/add_spot.dart';
import '../domain/entities/spot.dart';
import '../domain/repositories/spot_repository.dart';

final spotNotiferProvider =
    StateNotifierProvider<AddSpotFormNotifier, AsyncValue<ResponseResult>>(
  (ref) => AddSpotFormNotifier(
    spotRepository: ref.read(spotRepositoryProvider),
  ),
);

class AddSpotFormNotifier extends StateNotifier<AsyncValue<ResponseResult>> {
  AddSpotFormNotifier({
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
