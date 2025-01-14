import 'package:dbus/dbus.dart';
import 'package:demo_app/org_freedesktop_notifications.dart';

class BackgroundService {
  late OrgFreedesktopNotifications object;
  final client = DBusClient.session();

  Future<void> init() async {
    object = OrgFreedesktopNotifications(
      client,
      'org.freedesktop.Notifications',
      DBusObjectPath('/org/freedesktop/Notifications'),
    );

    object.actionInvoked.listen((event) async {
      // User pressed accept/deny from notification
      if (event.actionKey == "accept") {
        showNotification('button tapped!', 'it works!');
      }
    });

    showNotification(
      'Фоновая задача запущена!',
      'Нажмите подтвердить чтобы проверить обработку нажатия на кнопку уведомления',
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
