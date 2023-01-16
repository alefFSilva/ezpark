enum SpotType {
  error('Error'),
  car('Carro'),
  motorcycle('Moto'),
  truck('Caminhão');

  final String description;
  const SpotType(this.description);

  String toJson() => name;
  static SpotType fromJson(String json) => values.byName(json);
}
