class SpotsCount {
  SpotsCount({
    required this.spotsAvaliable,
    required this.spotsOcuppied,
  });
  final int spotsAvaliable;
  final int spotsOcuppied;

  int get spotTotal => spotsAvaliable + spotsOcuppied;
}
