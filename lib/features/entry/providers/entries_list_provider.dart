import 'dart:async';

import 'package:ezpark/features/entry/domain/repositories/entry_repository.dart';
import 'package:ezpark/features/entry/providers/entry_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  Future<void> delete({
    required String entryId,
  }) async {
    state = const AsyncValue.loading();
    final response = await _repository.delete(entryID: entryId);
    response.success
        ? refresh()
        : AsyncValue.error(
            response.errorMessage!,
            StackTrace.current,
          );
  }
}
