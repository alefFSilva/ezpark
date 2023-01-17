import '../../../../../core/network/response/entities/response_result.dart';
import '../entities/spot.dart';

abstract class SpotRepository {
  Future<ResponseResult<Spot>> addSpot(Spot addSpot);
  Future<ResponseResult<Spot>> saveSpot({
    required Spot spotToSave,
  });
  Future<ResponseResult<List<Spot>>> getSpots();
  Future<ResponseResult> remove({
    required int spotNumber,
  });
}
