import 'package:ezpark/features/spots/enums/spot_status.dart';

import '../../../../../core/network/response/entities/response_result.dart';
import '../entities/spot.dart';

abstract class SpotRepository {
  Future<ResponseResult<Spot>> addSpot(Spot addSpot);
  Future<ResponseResult<Spot>> saveSpot({
    required Spot spotToSave,
  });
  Future<ResponseResult<List<Spot>>> getSpots({
    SpotStatus? spotStatus,
  });
  Future<ResponseResult> remove({
    required int spotNumber,
  });

  Future<ResponseResult> setStatus({
    required int spotNumber,
    required SpotStatus spotStatus,
  });
}
