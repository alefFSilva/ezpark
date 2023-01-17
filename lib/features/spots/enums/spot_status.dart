import 'package:flutter/material.dart';

enum SpotStatus {
  error('Error', Colors.red),
  active('Disponível', Colors.green),
  occupied('Ocupada', Colors.red);

  final String description;
  final Color color;
  const SpotStatus(this.description, this.color);

  String toJson() => name;
  static SpotStatus fromJson(String json) => values.byName(json);
}
