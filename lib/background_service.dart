import 'package:dbus/dbus.dart';
import 'package:demo_app/org_freedesktop_notifications.dart';

class BackgroundService {
  late OrgFreedesktopNotifications object;
  final client = DBusClient.session();

  init() async {
    final client = DBusClient.session();

    try {
      // Request to own a D-Bus service name
      await client.requestName('ru.aurora.demo_app');

      print('Service registered: ru.aurora.demo_app');

      // Register an object path and expose methods

      print('Object registered: /ru/aurora/demo_app');
    } catch (e) {
      print('Failed to register service: $e');
    }
    object = OrgFreedesktopNotifications(
      client,
      'org.freedesktop.Notifications',
      DBusObjectPath('/org/freedesktop/Notifications'),
    );

    object.actionInvoked.listen((event) async {
      // User pressed accept/deny from notification
      if (event.actionKey == "accept") {
          showNotification('Кнопка обработана!', 'Все работает !');
      }
      },
    );
  }

  Future<int> showNotification(String title, String body) async {
    return await object.callNotify(
      "Workmanager Demo",
      0,
      ' ',
      title,
      body,
      ["accept", 'Подтвердить'],
      {
        "x-nemo-feedback": const DBusString("connection_status"),
        "urgency": const DBusByte(2),
        "x-aurora-essential": const DBusBoolean(true),
        "x-aurora-silent-actions": DBusArray.string(["accept", "deny"])
      },
      -1,
    );
  }
}
