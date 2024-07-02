import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart' as loc;
import 'package:google_api_headers/google_api_headers.dart' as header;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart' as places;
import 'package:flutter_app/core/functions/get_current_location.dart';
import 'package:flutter_app/core/localization/my_localization.dart';
import 'package:flutter_app/core/utilities/app_routes.dart';
import 'package:flutter_app/core/utilities/app_strings.dart';
import 'package:flutter_app/models/location_result.dart';
import 'package:flutter_app/views/widgets/main_button.dart';

class ActiveMapWidget extends StatefulWidget {
  const ActiveMapWidget({
    super.key,
    this.width,
    this.height,
    this.long,
    this.lat,
    this.address,
    this.zoom,
    this.onCameraMove,
    required this.onChanged,
    this.onlyShow = false,
    required this.isCurrentLocation,
  });
  final double? width;
  final double? height;
  final double? long;
  final double? lat;
  final String? address;
  final double? zoom;
  final bool onlyShow;
  final void Function(LocationResult newPosition) onChanged;
  final void Function(CameraPosition cameraPosition)? onCameraMove;
  final bool isCurrentLocation;
  @override
  State<ActiveMapWidget> createState() => _ActiveMapWidgetState();
}

class _ActiveMapWidgetState extends State<ActiveMapWidget> {
  static late LocationResult location;
  BitmapDescriptor positionIcon = BitmapDescriptor.defaultMarker;
  final Map<String, Marker> _markers = {};

  late GoogleMapController controller;
  setCurrentLocation() async {
    await getCurrentLocation().then((p) async {
      location.lat = p?.latitude ?? 24.470901;
      location.lng = p?.longitude ?? 39.612236;
      final marker = Marker(
        markerId: const MarkerId('myLocation'),
        position: LatLng(location.lat!, location.lng!),
      );
      setState(() {
        _markers['myLocation'] = marker;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(location.lat!, location.lng!), zoom: 14),
          ),
        );
      });
    });
    getLocationName(LatLng(location.lat!, location.lng!)).then((address) {
      setState(() {
        location = LocationResult(
            lat: location.lat!, lng: location.lng!, address: address ?? '');
      });
      log(location.lat.toString());
      log(location.lng.toString());
      final marker = Marker(
        markerId: const MarkerId('myLocation'),
        position: LatLng(location.lat!, location.lng!),
      );
      setState(() {
        _markers['myLocation'] = marker;
        location = LocationResult(
            lat: location.lat!, lng: location.lng!, address: address ?? '');
        widget.onChanged.call(location);
      });
    });
  }

  @override
  void initState() {
    location = LocationResult(
        lat: widget.lat, lng: widget.long, address: widget.address ?? '');
    final marker = Marker(
      markerId: const MarkerId('myLocation'),
      position: LatLng(location.lat!, location.lng!),
    );
    if (widget.isCurrentLocation) {
      setCurrentLocation();
    }
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _markers['myLocation'] = marker;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          GoogleMap(
            // zoomControlsEnabled: false,
            // mapType: MapType.terrain,
            myLocationButtonEnabled: true,
            initialCameraPosition: CameraPosition(
              target: location.position,
              zoom: widget.zoom ?? 14.5,
            ),
            onMapCreated: (GoogleMapController mcontroller) {
              controller = mcontroller;
              controller
                  .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                target: location.position,
                zoom: widget.zoom ?? 10.5,
              )));
              widget.onChanged.call(location);
            },
            markers: _markers.values.toSet(),
            onCameraMove: widget.onCameraMove,
            myLocationEnabled: true,
            onTap: widget.onlyShow
                ? (p) {}
                : (p) {
                    getLocationName(p).then((address) {
                      setState(() {
                        location = LocationResult(
                            lat: p.latitude, lng: p.longitude, address: '');
                      });
                      log(location.lat.toString());
                      log(location.lng.toString());
                      final marker = Marker(
                        markerId: const MarkerId('myLocation'),
                        position: LatLng(location.lat!, location.lng!),
                      );
                      setState(() {
                        _markers['myLocation'] = marker;
                        location = LocationResult(
                            lat: p.latitude,
                            lng: p.longitude,
                            address: address);
                        widget.onChanged.call(location);
                      });
                    });
                  },
            gestureRecognizers: {}
              ..add(Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer()))
              ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
              ..add(Factory<ScaleGestureRecognizer>(
                  () => ScaleGestureRecognizer()))
              ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer()))
              ..add(Factory<VerticalDragGestureRecognizer>(
                  () => VerticalDragGestureRecognizer())),
          ),
          Positioned(
            top: 60,
            right: 12,
            child: InkWell(
              onTap: () async {
                var result = await AppRoutes.routeTo(
                    context,
                    MapSelectLocPage(
                      myLocation: location,
                      onlyShow: widget.onlyShow,
                    ));
                if (result is LocationResult) {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    setState(() {
                      location = result;
                      final marker = Marker(
                        markerId: const MarkerId('myLocation'),
                        position: LatLng(location.lat!, location.lng!),
                      );
                      _markers['myLocation'] = marker;
                      widget.onChanged.call(result);
                      controller.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(target: result.position, zoom: 14),
                        ),
                      );
                    });
                  });
                }
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 2),
                  ],
                  color: Colors.white,
                ),
                child: const Icon(
                  Icons.fullscreen_rounded,
                  color: Colors.grey,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MapSelectLocPage extends StatefulWidget {
  const MapSelectLocPage({
    super.key,
    required this.myLocation,
    this.onlyShow = false,
  });
  final LocationResult myLocation;
  final bool onlyShow;
  @override
  State<MapSelectLocPage> createState() => _MapSelectLocPageState();
}

class _MapSelectLocPageState extends State<MapSelectLocPage> {
  // Location location = Location();
  final Map<String, Marker> _markers = {};
  bool isLoading = false;

  double? latitude;
  double? longitude;
  GoogleMapController? _controller;
  late final CameraPosition _kGooglePlex;

  Future<void> _handleSearch() async {
    places.Prediction? p = await loc.PlacesAutocomplete.show(
        context: context,
        apiKey: AppStrings.googleApikey,
        onError: onError, // call the onError function below
        mode: loc.Mode.overlay,
        language: getLocale.languageCode, //you can set any language for search
        strictbounds: false,
        types: [],
        components: [] // you can determine search for just one country
        );
    displayPrediction(p!);
  }

  void onError(places.PlacesAutocompleteResponse response) {}

  Future<void> displayPrediction(
    places.Prediction p,
  ) async {
    places.GoogleMapsPlaces placesG = places.GoogleMapsPlaces(
        apiKey: AppStrings.googleApikey,
        apiHeaders: await const header.GoogleApiHeaders().getHeaders());
    places.PlacesDetailsResponse detail =
        await placesG.getDetailsByPlaceId(p.placeId!);
// detail will get place details that user chose from Prediction search
    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;
    _markers.clear(); //clear old marker and set new one
    final marker = Marker(
      markerId: const MarkerId('deliveryMarker'),
      position: LatLng(lat, lng),
    );
    latitude = lat;
    longitude = lng;
    setState(() {
      locationSearch = p.description.toString();
      _markers['myLocation'] = marker;
      _controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, lng), zoom: 15),
        ),
      );
    });
  }

  setCurrentLocation() async {
    await getCurrentLocation().then((p) async {
      latitude = p?.latitude ?? 24.470901;
      longitude = p?.longitude ?? 39.612236;
      final marker = Marker(
        markerId: const MarkerId('myLocation'),
        position: LatLng(latitude!, longitude!),
      );
      setState(() {
        _markers['myLocation'] = marker;
        _controller?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(latitude!, longitude!), zoom: 14),
          ),
        );
      });
    });
  }

  @override
  void initState() {
    latitude = widget.myLocation.lat ?? 24.470901;
    longitude = widget.myLocation.lat ?? 39.612236;
    log(latitude.toString());
    log(longitude.toString());
    _kGooglePlex = CameraPosition(
      target: widget.myLocation.position,
      zoom: 14,
    );
    if (widget.myLocation.lat == null || widget.myLocation.lat == null) {
      setCurrentLocation();
    }
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      gotoLocation();
    });
  }

  gotoLocation() {
    final marker = Marker(
      markerId: const MarkerId('myLocation'),
      position: widget.myLocation.position,
    );
    setState(() {
      _markers['myLocation'] = marker;
      _controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: widget.myLocation.position, zoom: 14),
        ),
      );
    });
  }

  String? locationSearch;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: GoogleMap(
                mapType: MapType.normal,
                padding: const EdgeInsets.only(top: 80),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                initialCameraPosition: _kGooglePlex,
                markers: _markers.values.toSet(),
                onTap: widget.onlyShow
                    ? null
                    : (LatLng latlng) {
                        latitude = latlng.latitude;
                        longitude = latlng.longitude;
                        final marker = Marker(
                          markerId: const MarkerId('myLocation'),
                          position: LatLng(latitude!, longitude!),
                          // infoWindow: const InfoWindow(
                          //   title: 'Select Your Location',
                          // ),
                        );
                        getLocationName(LatLng(latitude!, longitude!))
                            .then((value) {
                          locationSearch = value;
                          setState(() {});
                        });
                        setState(() {
                          _markers['myLocation'] = marker;
                        });
                      },
                onMapCreated: (GoogleMapController controller) {
                  _controller = controller;
                },
              ),
            ),
            Positioned(
              // top: 20,
              child: InkWell(
                onTap: _handleSearch,
                // onTap: () async {
                //   var place = await loc.PlacesAutocomplete.show(
                //       context: context,
                //       apiKey: googleApikey,
                //       mode: loc.Mode.overlay,
                //       types: [],
                //       strictbounds: false,
                //       components: [
                //         places.Component(places.Component.country, 'np')
                //       ],
                //       //google_map_webservice package
                //       onError: (err) {
                //         print(err);
                //       });

                //   if (place != null) {
                //     setState(() {
                //       locationSearch = place.description.toString();
                //     });

                //     //form google_maps_webservice package
                //     final plist = places.GoogleMapsPlaces(
                //       apiKey: googleApikey,
                //       apiHeaders: await header.GoogleApiHeaders().getHeaders(),
                //       //from google_api_headers package
                //     );
                //     String placeid = place.placeId ?? "0";
                //     final detail = await plist.getDetailsByPlaceId(placeid);
                //     final geometry = detail.result.geometry!;
                //     final lat = geometry.location.lat;
                //     final lang = geometry.location.lng;
                //     var newlatlang = LatLng(lat, lang);

                //     //move map camera to selected place with animation
                //     _controller?.animateCamera(CameraUpdate.newCameraPosition(
                //         CameraPosition(target: newlatlang, zoom: 17)));
                //   }
                // },
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: BackButton(),
                      ),
                      Expanded(
                        child: Card(
                          child: Container(
                            padding: const EdgeInsets.all(0),
                            width: MediaQuery.of(context).size.width - 40,
                            child: ListTile(
                              title: Text(
                                locationSearch ?? tr(context).search,
                                style: const TextStyle(fontSize: 16),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: const Icon(Icons.search),
                              dense: true,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (!widget.onlyShow)
              Align(
                alignment: Alignment.bottomCenter,
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Container(
                        width: 150,
                        height: 45,
                        margin: const EdgeInsets.all(24),
                        child: MainButton(
                          borderColor: Colors.black,
                          color: Colors.black,
                          verticalPadding: 0,
                          onPressed: () async {
                            isLoading = true;
                            setState(() {});
                            await getLocationName(LatLng(latitude!, longitude!))
                                .then((address) {
                              WidgetsBinding.instance
                                  .addPostFrameCallback((timeStamp) async {
                                await AppRoutes.pop(
                                  context,
                                  result: LocationResult(
                                    lat: latitude,
                                    lng: longitude,
                                    address: address,
                                  ),
                                );
                              });
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.check_rounded,
                                  color: Colors.white),
                              const SizedBox(width: 16),
                              Text(
                                tr(context).ok,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
