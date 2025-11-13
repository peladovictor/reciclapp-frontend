import 'package:flutter_application_1/src/domain/useCases/geolocator/CreateMarkerUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/geolocator/GetMarkerUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/geolocator/GetPlacemarkDataUsesCase.dart';
import 'package:flutter_application_1/src/domain/useCases/geolocator/GetPolylineUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/geolocator/findPositionUseCase.dart';

class GeolocatorUseCases {
  FindPositionUsecase findPosition;

  CreateMarkerUseCase createMarker;
  GetMarkerUseCase getMarker;
  GetPlacemarkDataUsesCase getPlacemarkdata;
  GetPolylineUseCase getPolyline;

  GeolocatorUseCases({
    required this.findPosition,
    required this.createMarker,
    required this.getMarker,
    required this.getPlacemarkdata,
    required this.getPolyline,
  });
}
