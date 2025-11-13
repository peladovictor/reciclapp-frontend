import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/data/api/ApiKeyGoogle.dart';
import 'package:flutter_application_1/src/domain/models/PlacemarkData.dart';
import 'package:flutter_application_1/src/domain/repository/GeolocatorRespository.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/src/types/bitmap.dart';
import 'package:google_maps_flutter_platform_interface/src/types/marker.dart';

class GeolocatorRepositoryImpl implements GeolocatorRespository {
  @override
  Future<Position> findPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("La ubicacion no esta activada");
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Permiso no otorgado por el usuario permanentemente");
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Permiso no otorgado por el usuario permanentemente");
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  Future<BitmapDescriptor> createMarkerFromAsset(String path) async {
    ImageConfiguration configuration = ImageConfiguration();
    BitmapDescriptor descriptor = await BitmapDescriptor.asset(configuration, path);
    return descriptor;
  }

  @override
  Marker getMarker(String markerId, double lat, double lng, String title, String content,
      BitmapDescriptor imageMarker) {
    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
        markerId: id,
        icon: imageMarker,
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: title, snippet: content));
    return marker;
  }

  @override
  Future<PlacemarkData?> getPlacemarkData(CameraPosition cameraposition) async {
    try {
      double lat = cameraposition.target.latitude;
      double lng = cameraposition.target.longitude;
      List<Placemark> placemarksList = await placemarkFromCoordinates(lat, lng);
      if (placemarksList != null) {
        if (placemarksList.length > 0) {
          String direction = placemarksList[0].thoroughfare!;
          String street = placemarksList[0].subThoroughfare!;
          String city = placemarksList[0].locality!;
          String departament = placemarksList[0].administrativeArea!;
          PlacemarkData placemarkData = PlacemarkData(
              address: '$direction, $street, $city, $departament', lat: lat, lng: lng);
          return placemarkData;
        }
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }

    return null;
  }

  @override
  Future<List<LatLng>> getPolyline(
    LatLng pickUpLatLng,
    LatLng destinationLatLng,
  ) async {
    // ✅ NUEVO: pasa la API KEY al constructor
    final polylinePoints = PolylinePoints(apiKey: API_KEY_GOOGLE);

    // ✅ NUEVO: la llamada usa un PolylineRequest (sin googleApiKey:)
    final PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(pickUpLatLng.latitude, pickUpLatLng.longitude),
        destination: PointLatLng(destinationLatLng.latitude, destinationLatLng.longitude),
        mode: TravelMode.driving,
        wayPoints: [PolylineWayPoint(location: 'Santiago, Chile')],
      ),
    );

    final coords = <LatLng>[];
    if (result.points.isNotEmpty) {
      for (final p in result.points) {
        coords.add(LatLng(p.latitude, p.longitude));
      }
    }
    return coords;
  }
}
