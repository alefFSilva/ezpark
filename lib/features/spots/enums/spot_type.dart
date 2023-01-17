import 'package:flutter/material.dart';

enum SpotType {
  error('Error', Icons.error_outline_outlined),
  car('Carro', Icons.car_rental_outlined),
  motorcycle('Moto', Icons.motorcycle_outlined),
  truck('Caminhão', Icons.fire_truck_outlined);

  final String description;
  final IconData icon;
  const SpotType(this.description, this.icon);

  String toJson() => name;
  static SpotType fromJson(String json) => values.byName(json);
}
