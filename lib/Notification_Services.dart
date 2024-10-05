// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// class NotificationServices {
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

//   NotificationServices()
//       : _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   final AndroidInitializationSettings _androidInitializationSettings =
//       AndroidInitializationSettings('logo');

//   void initialiseNotification() async {
//     tz.initializeTimeZones();

//     InitializationSettings initializationSettings = InitializationSettings(
//       android: _androidInitializationSettings,
//     );

//     await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   Future<void> sendNotification(
//       String title, String body, String channelId, String channelName) async {
//     final AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//       channelId,
//       channelName,
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     final NotificationDetails notificationDetails = NotificationDetails(
//       android: androidNotificationDetails,
//     );

//     await _flutterLocalNotificationsPlugin.show(
//       0,
//       title,
//       body,
//       notificationDetails,
//     );
//   }

//   Future<void> scheduleNotification(
//       String title, String body, DateTime scheduledDateTime) async {
//     final tz.TZDateTime tzDateTime =
//         tz.TZDateTime.from(scheduledDateTime, tz.local);

//     final AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//       'scheduled_channel_id',
//       'Scheduled Notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     final NotificationDetails notificationDetails = NotificationDetails(
//       android: androidNotificationDetails,
//     );

//     await _flutterLocalNotificationsPlugin.zonedSchedule(
//       0,
//       title,
//       body,
//       tzDateTime,
//       notificationDetails,
//       androidAllowWhileIdle: true,
//       matchDateTimeComponents: DateTimeComponents.dateAndTime,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }
// }
