import 'package:customer_app/features/home/data/ride_models.dart';
import 'package:latlong2/latlong.dart';

abstract final class RideDemoData {
  RideDemoData._();

  static const center = LatLng(
    27.1865,
    31.1710,
  );

  static const pickup = LatLng(
    27.1902,
    31.1687,
  );

  static const car = LatLng(
    27.1890,
    31.1700,
  );

  static const nearbyCar = LatLng(
    27.1835,
    31.1658,
  );

  static const route = [
    LatLng(27.1902, 31.1687),
    LatLng(27.1888, 31.1695),
    LatLng(27.1872, 31.1700),
    LatLng(27.1850, 31.1710),
    LatLng(27.1835, 31.1720),
  ];

  static const drivers = [
    DriverInfo(
      name: 'Ahmed Mohamed',
      rating: 4.9,
      car: 'White Toyota Corolla',
      eta: '5 MIN AWAY',
      price: 240,
      plate: 'ABC 1234',
    ),
    DriverInfo(
      name: 'Ahmed Ali',
      rating: 4.8,
      car: 'Black Hyundai Elantra',
      eta: '2 MIN AWAY',
      price: 230,
      plate: 'XYZ 7632',
    ),
  ];
}