import 'package:ezpark/features/entry/enums/vehicle_colors_options.dart';

import '../../../spots/domain/entities/spot.dart';
import '../../enums/entry_status.dart';

class Entry {
  Entry({
    required this.id,
    required this.vehicleName,
    required this.vehiclePlate,
    required this.vehicleColor,
    required this.spot,
    required this.entryTime,
    required this.status,
    this.completedTime,
  });

  final String id;
  final String vehicleName;
  final String vehiclePlate;
  final VehicleColorsOption vehicleColor;
  final Spot spot;
  final EntryStatus status;
  final DateTime entryTime;
  final DateTime? completedTime;
}
