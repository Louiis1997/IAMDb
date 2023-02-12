class MapArguments {
  final double startLatitude;
  final double startLongitude;
  final String startFullAddress;
  final double? destinationLatitude;
  final double? destinationLongitude;
  final String? destinationFullAddress;
  final bool? withRouting;

  MapArguments({
    required this.startLatitude,
    required this.startLongitude,
    required this.startFullAddress,
    this.destinationLatitude,
    this.destinationLongitude,
    this.destinationFullAddress,
    this.withRouting,
  });
}
