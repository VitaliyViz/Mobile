import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

MqttClient getMqttClient(String server, String clientId) {
  final nativeClient = MqttServerClient(server, clientId);
  nativeClient.port = 1883;
  nativeClient.useWebSocket = false;
  return nativeClient;
}
