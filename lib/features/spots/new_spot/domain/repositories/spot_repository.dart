import 'package:dartz/dartz.dart';
import 'package:ezpark/features/spots/new_spot/domain/entities/add_spot.dart';
import 'package:ezpark/features/spots/new_spot/domain/entities/spot.dart';

import '../../../../../core/erros/failure.dart';

abstract class SpotRepository {
  Future<Either<Failure, Spot>> addSpot(AddSpot addSpot);
}
