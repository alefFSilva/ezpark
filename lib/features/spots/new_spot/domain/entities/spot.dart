import 'package:ezpark/features/spots/new_spot/presentation/enums/spot_type.dart';
import 'package:flutter/material.dart';

@immutable
class Spot {
  const Spot({
    required this.number,
    required this.spotType,
  });
  final int number;
  final SpotType spotType;
}
