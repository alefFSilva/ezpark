import 'package:ezpark/features/spots/new_spot/presentation/enums/spot_type.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/spot.dart';

@immutable
class SpotModel extends Spot {
  SpotModel({
    required super.number,
    required super.spotType,
  });

  factory SpotModel.fromJson({
    required Map<String, dynamic> data,
  }) {
    return SpotModel(
      number: data['number'],
      spotType: SpotType.fromJson(
        data['spotType'],
      ),
    );
  }
}
