import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/presentation/page/client/mapSeeker/bloc/ClientMapSeekerEvent.dart';
import 'package:flutter_application_1/src/presentation/widgets/DefaultButton.dart';
import 'package:flutter_application_1/src/presentation/widgets/GooglePlacesAutoComplete.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_application_1/src/presentation/page/client/mapSeeker/bloc/ClientMapSeekerBloc.dart';
import 'package:flutter_application_1/src/presentation/page/client/mapSeeker/bloc/ClientMapSeekerState.dart';
import 'package:google_places_flutter/model/prediction.dart';

class ClientMapSeekerPage extends StatefulWidget {
  const ClientMapSeekerPage({super.key});

  @override
  State<ClientMapSeekerPage> createState() => _ClientMapSeekerPageState();
}

class _ClientMapSeekerPageState extends State<ClientMapSeekerPage> {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  TextEditingController pickUpController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      context.read<ClientMapSeekerBloc>().add(ClientMapSeekerInitEvent());
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
                  controller.setMapStyle(
                      '[ { "elementType": "geometry", "stylers": [ { "color": "#ebe3cd" } ] }, { "elementType": "labels.text.fill", "stylers": [ { "color": "#523735" } ] }, { "elementType": "labels.text.stroke", "stylers": [ { "color": "#f5f1e6" } ] }, { "featureType": "administrative", "elementType": "geometry.stroke", "stylers": [ { "color": "#c9b2a6" } ] }, { "featureType": "administrative.land_parcel", "elementType": "geometry.stroke", "stylers": [ { "color": "#dcd2be" } ] }, { "featureType": "administrative.land_parcel", "elementType": "labels.text.fill", "stylers": [ { "color": "#ae9e90" } ] }, { "featureType": "landscape.natural", "elementType": "geometry", "stylers": [ { "color": "#dfd2ae" } ] }, { "featureType": "poi", "elementType": "geometry", "stylers": [ { "color": "#dfd2ae" } ] }, { "featureType": "poi", "elementType": "labels.text.fill", "stylers": [ { "color": "#93817c" } ] }, { "featureType": "poi.park", "elementType": "geometry.fill", "stylers": [ { "color": "#a5b076" } ] }, { "featureType": "poi.park", "elementType": "labels.text.fill", "stylers": [ { "color": "#447530" } ] }, { "featureType": "road", "elementType": "geometry", "stylers": [ { "color": "#f5f1e6" } ] }, { "featureType": "road.arterial", "elementType": "geometry", "stylers": [ { "color": "#fdfcf8" } ] }, { "featureType": "road.highway", "elementType": "geometry", "stylers": [ { "color": "#f8c967" } ] }, { "featureType": "road.highway", "elementType": "geometry.stroke", "stylers": [ { "color": "#e9bc62" } ] }, { "featureType": "road.highway.controlled_access", "elementType": "geometry", "stylers": [ { "color": "#e98d58" } ] }, { "featureType": "road.highway.controlled_access", "elementType": "geometry.stroke", "stylers": [ { "color": "#db8555" } ] }, { "featureType": "road.local", "elementType": "labels.text.fill", "stylers": [ { "color": "#806b63" } ] }, { "featureType": "transit.line", "elementType": "geometry", "stylers": [ { "color": "#dfd2ae" } ] }, { "featureType": "transit.line", "elementType": "labels.text.fill", "stylers": [ { "color": "#8f7d77" } ] }, { "featureType": "transit.line", "elementType": "labels.text.stroke", "stylers": [ { "color": "#ebe3cd" } ] }, { "featureType": "transit.station", "elementType": "geometry", "stylers": [ { "color": "#dfd2ae" } ] }, { "featureType": "water", "elementType": "geometry.fill", "stylers": [ { "color": "#b9d3c2" } ] }, { "featureType": "water", "elementType": "labels.text.fill", "stylers": [ { "color": "#92998d" } ] } ]');
                  if (!state.controller!.isCompleted) {
                    state.controller?.complete(controller);
                  }
                },
              ),
              Container(
                height: 130,
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
                      })
                    ],
                  ),
                ),
              ),
              _iconMyLocation(),
              Container(
                alignment: Alignment.bottomCenter,
                child: DefaultButton(
                    text: 'REVISAR RECOLECCIÓN',
                    margin: EdgeInsets.only(left: 50, right: 50, bottom: 50),
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
