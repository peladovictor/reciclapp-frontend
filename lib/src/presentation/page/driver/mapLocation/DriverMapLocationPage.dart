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

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<DriverMapLocationBloc>().add(DriverMapLocationInitEvent());
      context.read<DriverMapLocationBloc>().add(FindPosition());
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
                myLocationEnabled: true, // ← punto azul
                myLocationButtonEnabled: false, // botón de centrar (opcional)
                initialCameraPosition: state.cameraPosition,
                markers: Set<Marker>.of(state.markers.values),
                onCameraMove: (position) {
                  context
                      .read<DriverMapLocationBloc>()
                      .add(OnCameraMove(cameraPosition: position));
                },
                onMapCreated: (GoogleMapController controller) {
                  controller.setMapStyle(
                    '[ { "featureType": "all", "elementType": "labels.text.fill", "stylers": [ { "color": "#7c93a3" } ] } ]',
                  );
                  if (!state.controller!.isCompleted) {
                    state.controller!.complete(controller);
                  }
                },
              ),
              // BOTÓN REVISAR VIAJE
              Container(
                alignment: Alignment.bottomCenter,
                child: DefaultButton(
                    text: 'ACTIVAR LOCALIZACION',
                    margin: EdgeInsets.only(left: 50, right: 50, bottom: 90),
                    onPressed: () {}),
              )
            ],
          );
        },
      ),
    );
  }
}
