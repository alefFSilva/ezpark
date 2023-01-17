import 'package:ezpark/features/spots/enums/spot_status.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/spot.dart';
import '../../enums/spot_type.dart';

@immutable
class SpotModel extends Spot {
  const SpotModel({
    required super.number,
    required super.spotType,
    required super.spotStatus,
  });

  factory SpotModel.fromJson({
    required Map<String, dynamic> data,
  }) {
    return SpotModel(
      number: data['number'],
      spotType: SpotType.fromJson(
        data['type'],
      ),
      spotStatus: SpotStatus.fromJson(
        data['status'],
      ),
    );
  }
}
