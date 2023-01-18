import 'dart:async';

import 'package:ezpark/features/spots/enums/spot_status.dart';
import 'package:ezpark/features/spots/providers/spots_counter_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/response/entities/response_result.dart';
import '../data/repositories/spot_repository_impl.dart';
import '../domain/entities/spot.dart';
import '../domain/repositories/spot_repository.dart';

final spotsListProvider = AsyncNotifierProvider<SpotsListNotifier, List<Spot>>(
  () => SpotsListNotifier(),
);

final avaliableSpotsListProvider = FutureProvider<List<Spot>>(
  (ref) async {
    final repository = ref.read(spotRepositoryProvider);
    final response = await repository.getSpots(spotStatus: SpotStatus.active);
    return response.data!;
  },
);

class SpotsListNotifier extends AsyncNotifier<List<Spot>> {
  SpotsListNotifier();

  late final SpotRepository _repository;

  @override
  Future<List<Spot>> build() async {
    _repository = ref.read(spotRepositoryProvider);
    return await getSpots();
  }

  Future<void> refresh({
    SpotStatus? spotStatus,
  }) async {
    final response = await getSpots();
    ref.invalidate(spotsCounterProvider);
    state = AsyncValue.data(response);
  }

  Future<List<Spot>> getSpots({
    SpotStatus? spotStatus,
  }) async {
    state = const AsyncValue.loading();
    final response = await _repository.getSpots();
    if (!response.success) {
      state = AsyncValue.error(response.errorMessage!, StackTrace.current);
    }

    return response.data!;
  }

  Future<void> delete({
    required spotNumber,
  }) async {
    state = const AsyncValue.loading();
    final response = await _repository.remove(spotNumber: spotNumber);
    response.success
        ? refresh()
        : AsyncValue.error(
            response.errorMessage!,
            StackTrace.current,
          );
  }

  Future<ResponseResult> setStatus({
    required int spotNumber,
    required SpotStatus spotStatus,
  }) async {
    final result = await _repository.setStatus(
      spotNumber: spotNumber,
      spotStatus: spotStatus,
    );

    ref.invalidate(avaliableSpotsListProvider);
    ref.invalidate(spotsCounterProvider);
    ref.read(spotsListProvider.notifier).refresh();
    return result;
  }
}
