import 'package:flutter_application_1/src/domain/repository/SocketRepository.dart';

class ConnectSocketUseCase {
  SocketRepository socketRepository;

  ConnectSocketUseCase(this.socketRepository);

  run() => socketRepository.connect();
}
