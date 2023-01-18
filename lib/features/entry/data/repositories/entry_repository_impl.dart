import 'package:ezpark/features/entry/data/datasource/entry_datasource.dart';
import 'package:ezpark/features/entry/domain/entities/entry.dart';
import 'package:ezpark/core/network/response/entities/response_result.dart';
import 'package:flutter/material.dart';
import '../../domain/repositories/entry_repository.dart';

class EntryRepositoryImpl implements EntryRepository {
  EntryRepositoryImpl({
    required dataSource,
  }) : _datasource = dataSource;
  final EntryDatasource _datasource;

  @override
  Future<ResponseResult<void>> saveEntry({
    required Entry entryToSave,
    bool isNew = false,
  }) async {
    return await _datasource.saveEntry(
      entry: entryToSave,
      isNew: isNew,
    );
  }

  @override
  Future<ResponseResult<List<Entry>>> getEntries() async {
    return await _datasource.getEntries();
  }

  @override
  Future<ResponseResult<void>> delete({
    required String entryID,
  }) async =>
      await _datasource.remove(entryID: entryID);
}
