import 'dart:async';
import 'package:fan_control/services/mqtt_setup.dart';
import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';

class MqttService {
  final MqttClient client = getMqttClient(
    'broker.hivemq.com',
    'flutter_client_vitaliy_${DateTime.now().millisecondsSinceEpoch}',
  );

  final StreamController<String> _tempController =
      StreamController<String>.broadcast();
  bool _isInitialized = false;

  Stream<String> get temperatureStream {
    if (!_isInitialized) {
      _initMqtt();
    }
    return _tempController.stream;
  }

  Future<void> _initMqtt() async {
    _isInitialized = true;
    client.keepAlivePeriod = 20;

    final clientId = 'flutter_client_vitaliy_${DateTime.now().millisecond}';

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .startClean()
        .withWillQos(MqttQos.atMostOnce);
    client.connectionMessage = connMessage;

    try {
      await client.connect();
      if (client.connectionStatus!.state == MqttConnectionState.connected) {
        client.subscribe('vitaliy/test/temp', MqttQos.atMostOnce);

        client.updates!.listen((messages) {
          final recMess = messages[0].payload as MqttPublishMessage;
          final payload = MqttPublishPayload.bytesToStringAsString(
            recMess.payload.message,
          );
          _tempController.add(payload);
        });
      }
    } catch (e) {
      debugPrint('MQTT Error: $e');
      _isInitialized = false;
    }
  }
}
