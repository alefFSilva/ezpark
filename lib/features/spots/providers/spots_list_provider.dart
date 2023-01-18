import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/spot_repository_impl.dart';
import '../domain/entities/spot.dart';
import '../domain/repositories/spot_repository.dart';

final spotsListProvider = AsyncNotifierProvider<SpotsListNotifier, List<Spot>>(
  () => SpotsListNotifier(),
);

class SpotsListNotifier extends AsyncNotifier<List<Spot>> {
  SpotsListNotifier();

  late final SpotRepository _repository;

  @override
  Future<List<Spot>> build() async {
    _repository = ref.read(spotRepositoryProvider);
    return await getSpots();
  }

  Future<void> refresh() async {
    final response = await getSpots();
    state = AsyncValue.data(response);
  }

  Future<List<Spot>> getSpots() async {
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
}
