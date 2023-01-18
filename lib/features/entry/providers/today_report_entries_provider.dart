import 'package:ezpark/features/entry/providers/entry_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/entry.dart';

final todayEntriesReportProvider = FutureProvider<List<Entry>>(
  (ref) async {
    final entriesRepository = ref.read(entryRepositoryProvider);
    final response = await entriesRepository.getTodayEntries();

    return response.data!;
  },
);
