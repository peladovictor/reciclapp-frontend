import 'package:flutter_application_1/src/domain/useCases/socket/ConnectSocketUseCase.dart';
import 'package:flutter_application_1/src/domain/useCases/socket/DisconnectSocketUseCase.dart';

class SocketUseCases {
  ConnectSocketUseCase connect;
  DisconnectSocketUseCase disconnect;

  SocketUseCases({required this.connect, required this.disconnect});
}
