import 'package:ezpark/features/spots/enums/spot_status.dart';
import 'package:flutter/material.dart';

import '../../enums/spot_type.dart';

@immutable
class Spot {
  const Spot({
    required this.number,
    required this.spotType,
    required this.spotStatus,
  });
  final int number;
  final SpotType spotType;
  final SpotStatus spotStatus;

  factory Spot.fromJson(Map<String, dynamic> data) => Spot(
        number: data['number'],
        spotType: SpotType.fromJson(data['type']),
        spotStatus: SpotStatus.fromJson(data['status']),
      );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'number': number,
      'type': spotType.toJson(),
      'status': spotStatus.toJson(),
    };
  }
}
