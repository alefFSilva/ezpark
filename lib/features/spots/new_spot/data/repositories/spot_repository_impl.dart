import 'package:dartz/dartz.dart';
import 'package:ezpark/features/spots/new_spot/domain/entities/add_spot.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/erros/failure.dart';
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
  Future<Either<Failure, Spot>> addSpot(
    AddSpot addSpot,
  ) async =>
      await _datasource.add(addSpot);
}
