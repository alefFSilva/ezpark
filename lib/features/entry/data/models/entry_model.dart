import 'package:ezpark/features/entry/domain/entities/entry.dart';
import 'package:ezpark/features/entry/enums/vehicle_colors_options.dart';

import '../../../spots/domain/entities/spot.dart';

class EntryModel extends Entry {
  EntryModel({
    required super.id,
    required super.vehicleColor,
    required super.vehicleName,
    required super.vehiclePlate,
    required super.spot,
    required super.entryTime,
  });

  factory EntryModel.fromJson(String id, Map<String, dynamic> data) =>
      EntryModel(
        id: id,
        vehicleName: data['vehicleName'],
        vehiclePlate: data['vehiclePlate'],
        vehicleColor: VehicleColorsOption.fromJson(
          data['vehicleColor'],
        ),
        spot: Spot.fromJson(
          data['spot'],
        ),
        entryTime: DateTime.parse(
          data['entryTime'],
        ),
      );
}
