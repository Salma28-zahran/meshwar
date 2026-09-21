import 'package:customer_app/features/ride_type/ride_type.dart';

class RideData {
  const RideData({
    required this.rideType,
    required this.from,
    required this.to,
    this.passengers = 1,
    this.vehicleName,
  });

  final RideType rideType;

  final String from;
  final String to;

  final int passengers;

  final String? vehicleName;

  RideData copyWith({
    RideType? rideType,
    String? from,
    String? to,
    int? passengers,
    String? vehicleName,
  }) {
    return RideData(
      rideType: rideType ?? this.rideType,
      from: from ?? this.from,
      to: to ?? this.to,
      passengers: passengers ?? this.passengers,
      vehicleName: vehicleName ?? this.vehicleName,
    );
  }
}