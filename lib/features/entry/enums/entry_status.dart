enum EntryStatus {
  active('Ativa'),
  completed('Finalizada');

  final String description;
  const EntryStatus(this.description);
  String toJson() => name;

  static EntryStatus fromJson(
    String json,
  ) =>
      values.byName(json);
}
