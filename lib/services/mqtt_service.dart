import 'package:fan_control/services/mqtt_setup.dart';
import 'package:mqtt_client/mqtt_client.dart';

class MqttService {
  final MqttClient client = getMqttClient(
    'broker.hivemq.com',
    'flutter_client_vitaliy_${DateTime.now().millisecondsSinceEpoch}',
  );

  Stream<String> get temperatureStream async* {
    client.keepAlivePeriod = 20;
    
    final connMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_client_vitaliy')
        .startClean()
        .withWillQos(MqttQos.atMostOnce);
    client.connectionMessage = connMessage;

    try {
      await client.connect();
    } catch (e) {
      client.disconnect();
      yield 'Error';
      return;
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      client.subscribe('vitaliy/test/temp', MqttQos.atMostOnce);

      await for (final List<MqttReceivedMessage<MqttMessage>> messages 
          in client.updates!) {
        final recMess = messages[0].payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(
          recMess.payload.message,
        );
        yield payload;
      }
    }
  }
}
