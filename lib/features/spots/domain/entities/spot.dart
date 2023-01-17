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
}
