import 'package:ezpark/features/entry/domain/entities/entry.dart';

import '../../../../../core/network/response/entities/response_result.dart';

abstract class EntryRepository {
  Future<ResponseResult<void>> saveEntry({
    required Entry entryToSave,
    bool isNew = false,
  });

  Future<ResponseResult<List<Entry>>> getEntries();
  Future<ResponseResult<void>> delete({
    required String entryID,
  });
}
