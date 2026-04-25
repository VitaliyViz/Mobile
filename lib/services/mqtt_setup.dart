import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

MqttClient getMqttClient(String server, String clientId) {
  if (kIsWeb) {
    final webClient = MqttBrowserClient('wss://$server/mqtt', clientId);
    webClient.port = 8884;
    webClient.websocketProtocols = MqttClientConstants.protocolsSingleDefault;
    return webClient;
  } else {
    final nativeClient = MqttServerClient(server, clientId);
    nativeClient.port = 1883;
    nativeClient.useWebSocket = false;
    return nativeClient;
  }
}
