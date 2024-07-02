import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_app/core/localization/my_localization.dart';
import 'package:flutter_app/core/utilities/app_routes.dart';

Future<Position?> getCurrentLocation() async {
  bool? access = false;
  await Geolocator.checkPermission().then((value) async {
    if (value == LocationPermission.whileInUse ||
        value == LocationPermission.always) {
      access = true;
      return true;
    } else if (value == LocationPermission.denied) {
      await Future.delayed(const Duration(milliseconds: 100), () async {
        return await showDialog<bool>(
          context: AppNavigator.context,
          builder: (builder) {
            return AlertDialog(
              title: Text(tr(AppNavigator.context).location_access),
              content: Text(tr(AppNavigator.context).location_dcs),
              actions: [
                TextButton(
                  onPressed: () {
                    AppRoutes.pop(AppNavigator.context, result: true);
                  },
                  child: Text(tr(AppNavigator.context).ok),
                ),
                TextButton(
                  onPressed: () {
                    AppRoutes.pop(AppNavigator.context, result: false);
                  },
                  child: Text(tr(AppNavigator.context).cancel),
                ),
              ],
            );
          },
        );
      }).then((value) {
        access = value;
      });
    }
  });
  if (!(access ?? false)) {
    return null;
  }
  await handleLocationPermission().then(
    (value) {
      if (!value) return null;
    },
  );

  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
}

Future<String?> getLocationName(LatLng locationData) async {
  try {
    final isAr = getLocale.languageCode == 'ar';
    List<Placemark> placemarks = await placemarkFromCoordinates(
        locationData.latitude, locationData.longitude,
        localeIdentifier: isAr ? 'ar_EG' : 'en_US');

    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      String street = placemarks.map((e) => e.street).toSet().join(' - ');
      street = street.replaceAll(',', ' - ');
      street = street.replaceAll('،', ' - ');
      street = street.replaceAll('،', ' - ');
      String address = street;
      for (var p in placemarks) {
        if (p.postalCode != null && p.postalCode!.isNotEmpty) {
          address = address.replaceAll(p.postalCode!, ' ');
        }
      }
      List<String> l =
          '${place.country} - ${place.administrativeArea} - ${place.subAdministrativeArea} - ${place.locality} - ${place.subLocality} - ${place.thoroughfare} - ${place.subThoroughfare} - $address'
              .split(' - ');
      l = l.map((e) => e.trim()).toSet().toList();
      l = l.map((e) => e.contains('+') ? '' : e).toSet().toList()
        ..removeWhere((e) => e.isEmpty);
      return l.join(' - ');
    }
    await getLocationName(locationData);
    return null;
  } catch (e) {
    await getLocationName(locationData);
    debugPrint("Error fetching place name: $e");
    return null;
  }
}

Future<bool> handleLocationPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {}
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // showSnackbar('Location permissions are denied', error: true);
      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    permission = await Geolocator.requestPermission();
    // showSnackbar(
    //     'Location permissions are permanently denied, we cannot request permissions.',
    //     error: true);
    return false;
  }
  return true;
}
