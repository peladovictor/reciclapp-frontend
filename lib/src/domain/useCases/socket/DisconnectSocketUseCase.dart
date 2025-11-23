import 'package:flutter_application_1/src/domain/repository/SocketRepository.dart';

class DisconnectSocketUseCase {
  SocketRepository socketRepository;

  DisconnectSocketUseCase(this.socketRepository);

  run() => socketRepository.disconnect();
}
