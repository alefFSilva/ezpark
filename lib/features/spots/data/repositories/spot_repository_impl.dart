import 'package:ezpark/core/network/response/entities/response_result.dart';
import 'package:ezpark/features/spots/enums/spot_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/spot.dart';
import '../../domain/repositories/spot_repository.dart';
import '../datasources/spot_datasource.dart';

final spotRepositoryProvider = Provider<SpotRepository>(
  (ref) {
    final spotDatasource = ref.read(spotDatasourceProvider);
    return SpotRepositoryImpl(spotDatasource: spotDatasource);
  },
);

class SpotRepositoryImpl implements SpotRepository {
  SpotRepositoryImpl({
    required SpotDatasource spotDatasource,
  }) : _datasource = spotDatasource;

  final SpotDatasource _datasource;
  @override
  Future<ResponseResult<Spot>> addSpot(
    Spot addSpot,
  ) async =>
      await _datasource.addNew(addSpot);

  @override
  Future<ResponseResult<List<Spot>>> getSpots({
    SpotStatus? spotStatus,
  }) async =>
      await _datasource.getSpots(spotStatus: spotStatus);

  @override
  Future<ResponseResult> remove({
    required int spotNumber,
  }) =>
      _datasource.remove(spotNumber: spotNumber);

  @override
  Future<ResponseResult<Spot>> saveSpot({
    required Spot spotToSave,
  }) {
    return _datasource.saveSpot(
      spot: spotToSave,
    );
  }

  @override
  Future<ResponseResult> setStatus({
    required int spotNumber,
    required SpotStatus spotStatus,
  }) =>
      _datasource.setStatus(
        spotNumber: spotNumber,
        spotStatus: spotStatus,
      );
}
