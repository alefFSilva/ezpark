import 'package:ezpark/features/spots/new_spot/presentation/enums/spot_type.dart';
import 'package:flutter/material.dart';

@immutable
class AddSpot {
  const AddSpot({
    required this.spotNumber,
    required this.spotType,
  });
  final int spotNumber;
  final SpotType spotType;

  factory AddSpot.empty() => const AddSpot(
        spotNumber: -1,
        spotType: SpotType.error,
      );

  AddSpot copyWith({
    int? spotNumber,
    SpotType? spotType,
  }) {
    return AddSpot(
      spotNumber: spotNumber ?? this.spotNumber,
      spotType: spotType ?? this.spotType,
    );
  }
}
