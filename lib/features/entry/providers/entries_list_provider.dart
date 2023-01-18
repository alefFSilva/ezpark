import 'dart:async';

import 'package:ezpark/features/entry/domain/repositories/entry_repository.dart';
import 'package:ezpark/features/entry/providers/entry_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/entry.dart';

final entriesListProvider =
    AsyncNotifierProvider<SpotsListNotifier, List<Entry>>(
  () => SpotsListNotifier(),
);

class SpotsListNotifier extends AsyncNotifier<List<Entry>> {
  SpotsListNotifier();

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
}
