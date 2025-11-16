import 'dart:ui' as ui;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_application_1/src/domain/repository/GeolocatorRespository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateMarkerUseCase {
  final GeolocatorRespository geolocatorRespository;

  CreateMarkerUseCase(this.geolocatorRespository);

  Future<BitmapDescriptor> run(
    String assetPath, {
    int width = 80, // 👈 tamaño por defecto del ícono
  }) async {
    // Cargar el asset del marker
    final byteData = await rootBundle.load(assetPath);

    // Redimensionar al ancho indicado
    final codec = await ui.instantiateImageCodec(
      byteData.buffer.asUint8List(),
      targetWidth: width,
    );

    final frameInfo = await codec.getNextFrame();

    final resizedBytes = await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(resizedBytes!.buffer.asUint8List());
  }
}
