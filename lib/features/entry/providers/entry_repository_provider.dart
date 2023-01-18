import 'package:ezpark/features/entry/data/datasource/entry_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/entry_repository_impl.dart';
import '../domain/repositories/entry_repository.dart';

final entryRepositoryProvider = Provider<EntryRepository>(
  (ref) {
    return EntryRepositoryImpl(
      dataSource: EntryDatasourceImpl(),
    );
  },
);
