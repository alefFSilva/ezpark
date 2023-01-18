import 'package:flutter/material.dart';

enum VehicleColorsOption {
  white('Branco', Colors.white),
  black('Preto', Colors.black),
  blue('Azul', Colors.blue),
  green('Verde', Colors.green),
  purple('Roxo', Colors.purple),
  grey('Cinza', Colors.grey),
  yellow('Amarelo', Colors.yellow),
  red('Vermelho', Colors.red);

  const VehicleColorsOption(this.description, this.color);
  final String description;
  final Color color;

  String toJson() => name;
  static VehicleColorsOption fromJson(String json) => values.byName(json);
}
