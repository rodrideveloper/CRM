import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings: settings);
    _initialized = true;
  }

  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      final granted = await android?.requestNotificationsPermission();
      await android?.requestExactAlarmsPermission();
      return granted ?? false;
    } else if (Platform.isIOS) {
      final ios = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      final granted = await ios?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }
    return false;
  }

  /// Schedule a notification for a task due date.
  /// Fires 1 hour before due date (or immediately if less than 1h away).
  Future<void> scheduleTaskReminder({
    required String taskId,
    required String title,
    required DateTime dueDate,
    String? clientName,
  }) async {
    final id = taskId.hashCode.abs() % 2147483647;
    final body = clientName != null
        ? 'Cliente: $clientName'
        : 'Tarea pendiente';

    // Schedule 1 hour before
    final scheduledDate = dueDate.subtract(const Duration(hours: 1));
    final now = DateTime.now();

    if (scheduledDate.isBefore(now)) {
      // If less than 1h away but still in the future, show at due time
      if (dueDate.isAfter(now)) {
        await _scheduleAt(id, title, body, dueDate);
      }
      // If already past, don't schedule
      return;
    }

    await _scheduleAt(id, title, body, scheduledDate);
  }

  /// Schedule a follow-up reminder for a client.
  Future<void> scheduleFollowUpReminder({
    required String clientId,
    required String clientName,
    required DateTime followUpDate,
  }) async {
    // Use a different hash space to avoid collisions with task notifications
    final id = (clientId.hashCode.abs() + 1000000) % 2147483647;

    await _scheduleAt(
      id,
      '📞 Seguimiento: $clientName',
      'Tenés un seguimiento programado para hoy',
      followUpDate,
    );
  }

  Future<void> cancelTaskReminder(String taskId) async {
    final id = taskId.hashCode.abs() % 2147483647;
    await _plugin.cancel(id: id);
  }

  Future<void> cancelFollowUpReminder(String clientId) async {
    final id = (clientId.hashCode.abs() + 1000000) % 2147483647;
    await _plugin.cancel(id: id);
  }

  Future<void> _scheduleAt(
    int id,
    String title,
    String body,
    DateTime dateTime,
  ) async {
    final tzDateTime = tz.TZDateTime.from(dateTime, tz.local);

    if (tzDateTime.isBefore(tz.TZDateTime.now(tz.local))) return;

    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tzDateTime,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'crm_tasks',
          'Tareas y Recordatorios',
          channelDescription: 'Notificaciones de tareas y seguimientos',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }
}
