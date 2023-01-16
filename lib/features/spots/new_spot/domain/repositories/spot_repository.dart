import 'package:dartz/dartz.dart';
import 'package:ezpark/features/spots/new_spot/domain/entities/add_spot.dart';
import 'package:ezpark/features/spots/new_spot/domain/entities/spot.dart';

import '../../../../../core/erros/failure.dart';
import '../../../../../core/network/response/entities/response_result.dart';

abstract class SpotRepository {
  Future<ResponseResult<Spot>> addSpot(AddSpot addSpot);
}
