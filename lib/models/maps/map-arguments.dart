class MapArguments {

  final double userLatitude;
  final double userLongitude;
  final String userFullAddress;
  final double? destinationLatitude;
  final double? destinationLongitude;
  final String? destinationFullAddress;

  MapArguments({
    required this.userLatitude,
    required this.userLongitude,
    required this.userFullAddress,
    this.destinationLatitude,
    this.destinationLongitude,
    this.destinationFullAddress,
  });
}