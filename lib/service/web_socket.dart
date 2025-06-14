import 'package:web_socket_channel/web_socket_channel.dart';

final channel = WebSocketChannel.connect(
  Uri.parse(
    'ws://your_server_ip:port/ws',
  ), // Replace with your backend WebSocket URL
);
