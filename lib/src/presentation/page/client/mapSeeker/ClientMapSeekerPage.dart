import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/presentation/page/client/mapSeeker/bloc/ClientMapSeekerEvent.dart';
import 'package:flutter_application_1/src/presentation/widgets/DefaultButton.dart';
import 'package:flutter_application_1/src/presentation/widgets/GooglePlacesAutoComplete.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_application_1/src/presentation/page/client/mapSeeker/bloc/ClientMapSeekerBloc.dart';
import 'package:flutter_application_1/src/presentation/page/client/mapSeeker/bloc/ClientMapSeekerState.dart';
import 'package:google_places_flutter/model/prediction.dart';

// Dirección fija de la planta de reciclaje
const String kRecyclingPlantAddress =
    'Planta de Reciclaje Recoleta, Av. Einstein 523, Recoleta';

// Coordenadas fijas de la planta (para el Bloc)
const double kRecyclingPlantLat = -33.4028356;
const double kRecyclingPlantLng = -70.6470629;

class ClientMapSeekerPage extends StatefulWidget {
  const ClientMapSeekerPage({super.key});

  @override
  State<ClientMapSeekerPage> createState() => _ClientMapSeekerPageState();
}

class _ClientMapSeekerPageState extends State<ClientMapSeekerPage> {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-33.402752, -70.6499649),
    zoom: 14.4746,
  );

  TextEditingController pickUpController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ClientMapSeekerBloc>().add(ClientMapSeekerInitEvent());
      context.read<ClientMapSeekerBloc>().add(ConnectSocketIO());
      context.read<ClientMapSeekerBloc>().add(FindPosition());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ClientMapSeekerBloc, ClientMapSeekerState>(
        builder: (context, state) {
          return Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: state.cameraPosition,
                markers: Set<Marker>.of(state.markers.values),
                onCameraMove: (CameraPosition cameraPsition) {
                  context
                      .read<ClientMapSeekerBloc>()
                      .add(OnCameraMove(cameraPosition: cameraPsition));
                },
                onCameraIdle: () async {
                  context.read<ClientMapSeekerBloc>().add(OnCameraIdle());
                  pickUpController.text = state.placemarkData?.address ?? '';
                  if (state.placemarkData != null) {
                    context.read<ClientMapSeekerBloc>().add(OnAutoCompletedPickUpSelected(
                        lat: state.placemarkData!.lat,
                        lng: state.placemarkData!.lng,
                        pickUpDescription: state.placemarkData!.address));
                  }
                },
                onMapCreated: (GoogleMapController controller) {
                  // tu setMapStyle, etc.
                  if (!state.controller.isCompleted) {
                    state.controller.complete(controller);
                  }
                },
              ),
              Container(
                height: 170,
                margin: EdgeInsets.only(left: 30, right: 30, top: 10),
                child: Card(
                  surfaceTintColor: Colors.white,
                  child: Column(
                    children: [
                      Googleplacesautocomplete(pickUpController, 'Recoger en',
                          (Prediction prediction) {
                        if (prediction != null) {
                          context.read<ClientMapSeekerBloc>().add(ChangeMapCameraPosition(
                                lat: double.parse(prediction.lat!),
                                lng: double.parse(prediction.lng!),
                              ));
                          context.read<ClientMapSeekerBloc>().add(
                              OnAutoCompletedPickUpSelected(
                                  lat: double.parse(prediction.lat!),
                                  lng: double.parse(prediction.lng!),
                                  pickUpDescription: prediction.description ?? ''));
                        }
                      }),
                      // SizedBox(height: 15),
                      Divider(
                        color: Colors.grey[130],
                      ),
                      Googleplacesautocomplete(destinationController, 'Dejar en',
                          (Prediction prediction) {
                        context.read<ClientMapSeekerBloc>().add(
                            OnAutoCompletedDestinationSelected(
                                lat: double.parse(prediction.lat!),
                                lng: double.parse(prediction.lng!),
                                destinationDescription: prediction.description ?? ''));
                      }),
                      // 👇 NUEVO BOTÓN: usar planta de reciclaje
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // 1) Autocompletar el campo "Dejar en"
                            destinationController.text = kRecyclingPlantAddress;

                            // 2) Avisar al Bloc como si hubieras elegido una dirección del buscador
                            context.read<ClientMapSeekerBloc>().add(
                                  OnAutoCompletedDestinationSelected(
                                    lat: kRecyclingPlantLat,
                                    lng: kRecyclingPlantLng,
                                    destinationDescription: kRecyclingPlantAddress,
                                  ),
                                );
                          },
                          icon: const Icon(
                            Icons.recycling,
                            size: 18,
                          ),
                          label: const Text(
                            'Usar planta de reciclaje',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1AB25B), // verde
                            foregroundColor: Colors.white, // texto + icono blanco
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            minimumSize: const Size(0, 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _iconMyLocation(),
              Container(
                alignment: Alignment.bottomCenter,
                child: DefaultButton(
                    text: 'REVISAR RECOLECCIÓN',
                    margin: EdgeInsets.only(left: 50, right: 50, bottom: 80),
                    onPressed: () {
                      Navigator.pushNamed(context, 'client/map/booking', arguments: {
                        'pickUpLatLng': state.pickUpLatLng,
                        'destinationLatLng': state.destinationLatlng,
                        'pickUpDescription': state.pickUpDescription,
                        'destinationDescription': state.destinationDescription,
                      });
                    }),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _iconMyLocation() {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      alignment: Alignment.center,
      child: Image.asset(
        'assets/img/location_blue.png',
        width: 50,
        height: 50,
      ),
    );
  }
}
