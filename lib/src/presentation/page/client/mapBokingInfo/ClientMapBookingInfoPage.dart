import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/presentation/page/client/mapBokingInfo/ClientMapBookingInfoContent.dart';
import 'package:flutter_application_1/src/presentation/page/client/mapBokingInfo/bloc/ClientMapBookingInfoBloc.dart';
import 'package:flutter_application_1/src/presentation/page/client/mapBokingInfo/bloc/ClientMapBookingInfoEvent.dart';
import 'package:flutter_application_1/src/presentation/page/client/mapBokingInfo/bloc/ClientMapBookingInfoState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClientMapBookingInfoPage extends StatefulWidget {
  const ClientMapBookingInfoPage({super.key});

  @override
  State<ClientMapBookingInfoPage> createState() => _ClientMapBookingInfoPageState();
}

class _ClientMapBookingInfoPageState extends State<ClientMapBookingInfoPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ClientMapBookingInfoBloc>().add(ClientMapBookingInfoInitEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    LatLng pickUpLatLng = arguments['pickUpLatLng'];
    LatLng destinationLatLng = arguments['destinationLatLng'];
    String pickUpDestination = arguments['pickUpDescription'];
    String destinationDescription = arguments['destinationDescription'];
    print('pickUpLatLng: ${pickUpLatLng.toJson()}');
    print('destinationLatLng: ${destinationLatLng.toJson()}');
    print('pickUpDestination: ${pickUpDestination}');
    print('destinationDescription: ${destinationDescription}');
    return Scaffold(
      body: BlocBuilder<ClientMapBookingInfoBloc, ClientMapBookingInfoState>(
        builder: (context, state) {
          return ClientMapBookingInfoContent(state);
        },
      ),
    );
  }
}
