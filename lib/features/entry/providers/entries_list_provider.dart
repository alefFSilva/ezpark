import 'dart:async';

import 'package:ezpark/features/entry/domain/repositories/entry_repository.dart';
import 'package:ezpark/features/entry/enums/entry_status.dart';
import 'package:ezpark/features/entry/providers/entry_repository_provider.dart';
import 'package:ezpark/features/spots/enums/spot_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/response/entities/response_result.dart';
import '../../spots/providers/spots_list_provider.dart';
import '../domain/entities/entry.dart';

final entriesListProvider =
    AsyncNotifierProvider<EntriesListNotifier, List<Entry>>(
  () => EntriesListNotifier(),
);

class EntriesListNotifier extends AsyncNotifier<List<Entry>> {
  EntriesListNotifier();

  late final EntryRepository _repository;

  @override
  Future<List<Entry>> build() async {
    _repository = ref.read(entryRepositoryProvider);
    return await getEntries();
  }

  Future<List<Entry>> getEntries() async {
    state = const AsyncValue.loading();
    final response = await _repository.getEntries();
    if (!response.success) {
      state = AsyncValue.error(response.errorMessage!, StackTrace.current);
    }
    return response.data!;
  }

  Future<void> refresh() async {
    final response = await getEntries();
    state = AsyncValue.data(response);
  }

  Future<ResponseResult> setStatus({
    required String entryID,
    required int spotNumber,
    required EntryStatus status,
  }) async {
    final result = await _repository.setStatus(
      entryID: entryID,
      status: status,
    );

    ref.invalidate(avaliableSpotsListProvider);
    ref.read(spotsListProvider.notifier).setStatus(
          spotNumber: spotNumber,
          spotStatus: SpotStatus.active,
        );
    refresh();
    return result;
  }

  Future<void> delete({
    required String entryId,
    required int spotNumber,
  }) async {
    state = const AsyncValue.loading();
    final response = await _repository.delete(entryID: entryId);
    if (response.success) {
      ref.read(spotsListProvider.notifier).setStatus(
            spotNumber: spotNumber,
            spotStatus: SpotStatus.active,
          );
      refresh();
    } else {
      AsyncValue.error(
        response.errorMessage!,
        StackTrace.current,
      );
    }
  }
}
