import 'package:ezpark/features/entry/enums/vehicle_colors_options.dart';

import '../../../spots/domain/entities/spot.dart';

class Entry {
  Entry({
    required this.id,
    required this.vehicleName,
    required this.vehiclePlate,
    required this.vehicleColor,
    required this.spot,
    required this.entryTime,
  });

  final String id;
  final String vehicleName;
  final String vehiclePlate;
  final VehicleColorsOption vehicleColor;
  final Spot spot;
  final DateTime entryTime;
}
