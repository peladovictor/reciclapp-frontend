import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_1/src/presentation/page/driver/mapLocation/bloc/DriverMapLocationEvent.dart';
import 'package:flutter_application_1/src/presentation/page/driver/mapLocation/bloc/DriverMapLocationBloc.dart';
import 'package:flutter_application_1/src/presentation/page/driver/mapLocation/bloc/DriverMapLocationState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_application_1/src/presentation/widgets/DefaultButton.dart';

class DriverMapLocationPage extends StatefulWidget {
  const DriverMapLocationPage({super.key});

  @override
  State<DriverMapLocationPage> createState() => _DriverMapLocationPageState();
}

class _DriverMapLocationPageState extends State<DriverMapLocationPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<DriverMapLocationBloc>().add(DriverMapLocationInitEvent());
      context.read<DriverMapLocationBloc>().add(ConnectSocketIO());
      context.read<DriverMapLocationBloc>().add(FindPosition());
    });
  }

  @override
  void dispose() {
    super.dispose();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        context.read<DriverMapLocationBloc>().add(DisconnectSocketIO());
        context.read<DriverMapLocationBloc>().add(StopLocation());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DriverMapLocationBloc, DriverMapLocationState>(
        builder: (context, state) {
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: state.cameraPosition,
                markers: Set<Marker>.of(state.markers.values),
                onMapCreated: (GoogleMapController controller) {
                  controller.setMapStyle(
                      '[ { "featureType": "all", "elementType": "labels.text.fill", "stylers": [ { "color": "#ffffff" } ] }, { "featureType": "all", "elementType": "labels.text.stroke", "stylers": [ { "color": "#000000" }, { "lightness": 13 } ] }, { "featureType": "administrative", "elementType": "geometry.fill", "stylers": [ { "color": "#000000" } ] }, { "featureType": "administrative", "elementType": "geometry.stroke", "stylers": [ { "color": "#144b53" }, { "lightness": 14 }, { "weight": 1.4 } ] }, { "featureType": "landscape", "elementType": "all", "stylers": [ { "color": "#08304b" } ] }, { "featureType": "poi", "elementType": "geometry", "stylers": [ { "color": "#0c4152" }, { "lightness": 5 } ] }, { "featureType": "road.highway", "elementType": "geometry.fill", "stylers": [ { "color": "#000000" } ] }, { "featureType": "road.highway", "elementType": "geometry.stroke", "stylers": [ { "color": "#0b434f" }, { "lightness": 25 } ] }, { "featureType": "road.arterial", "elementType": "geometry.fill", "stylers": [ { "color": "#000000" } ] }, { "featureType": "road.arterial", "elementType": "geometry.stroke", "stylers": [ { "color": "#0b3d51" }, { "lightness": 16 } ] }, { "featureType": "road.local", "elementType": "geometry", "stylers": [ { "color": "#000000" } ] }, { "featureType": "transit", "elementType": "all", "stylers": [ { "color": "#146474" } ] }, { "featureType": "water", "elementType": "all", "stylers": [ { "color": "#021019" } ] } ]');

                  final mapController = state.controller; // 👈 tomamos una copia local

                  // Solo lo usamos si NO es null y aún no está completado
                  if (mapController != null && !mapController.isCompleted) {
                    mapController.complete(controller);
                  }
                },
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: DefaultButton(
                    text: 'DETENER LOCALIZACION',
                    margin: EdgeInsets.only(left: 50, right: 50, bottom: 80),
                    onPressed: () {
                      context.read<DriverMapLocationBloc>().add(DisconnectSocketIO());
                      context.read<DriverMapLocationBloc>().add(StopLocation());
                    }),
              )
            ],
          );
        },
      ),
    );
  }
}
