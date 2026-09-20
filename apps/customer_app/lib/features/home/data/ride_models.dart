enum RideStage {
  price,
  findingDriver,
  selectDriver,
  reviewRide,
  driverOnWay,
  driverArrived,
  rideInProgress,
}

class DriverInfo {
  const DriverInfo({
    required this.name,
    required this.rating,
    required this.car,
    required this.eta,
    required this.price,
    required this.plate,
  });

  final String name;
  final double rating;
  final String car;
  final String eta;
  final int price;
  final String plate;
}