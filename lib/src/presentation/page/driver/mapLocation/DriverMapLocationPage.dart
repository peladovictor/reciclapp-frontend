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
  late final DriverMapLocationBloc _bloc; // 👈 referencia local

  @override
  void initState() {
    super.initState();

    // guardamos el bloc una sola vez
    _bloc = context.read<DriverMapLocationBloc>();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _bloc.add(DriverMapLocationInitEvent());
      _bloc.add(FindPosition());
    });
  }

  @override
  void dispose() {
    // aquí ya no usamos context, usamos la referencia
    _bloc.add(StopLocation());
    super.dispose();
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
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                initialCameraPosition: state.cameraPosition,
                markers: Set<Marker>.of(state.markers.values),
                onMapCreated: (GoogleMapController controller) {
                  controller.setMapStyle(
                    '[ { "featureType": "all", "elementType": "labels.text.fill", "stylers": [ { "color": "#7c93a3" } ] } ]',
                  );
                  // controller ya no es nulable en tu state
                  if (!state.controller.isCompleted) {
                    state.controller.complete(controller);
                  }
                },
              ),
              // BOTÓN DETENER LOCALIZACION
              Container(
                alignment: Alignment.bottomCenter,
                child: DefaultButton(
                  text: 'DETENER LOCALIZACION',
                  margin: const EdgeInsets.only(left: 50, right: 50, bottom: 90),
                  onPressed: () {
                    _bloc.add(StopLocation());
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
