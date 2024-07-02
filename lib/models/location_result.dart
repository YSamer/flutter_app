import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationResult {
  LocationResult({
    required this.lat,
    required this.lng,
    required this.address,
  });
  double? lat;
  double? lng;
  String? address;

  LatLng get position => LatLng(lat ?? 0.0, lng ?? 0.0);
}
