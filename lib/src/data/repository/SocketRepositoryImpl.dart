import 'package:flutter_application_1/src/domain/repository/SocketRepository.dart';
import 'package:socket_io_client/src/socket.dart';

class SocketRepositoryImpl implements SocketRepository {
  Socket socket;

  SocketRepositoryImpl(this.socket);

  @override
  Socket connect() {
    return socket.connect();
  }

  @override
  Socket disconnect() {
    return socket.disconnect();
  }
}
