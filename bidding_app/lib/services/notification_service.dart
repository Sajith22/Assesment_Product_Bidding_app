// ─────────────────────────────────────────────────────────────────────────────
// services/notification_service.dart
// FCM setup + Firestore notification records.
// ─────────────────────────────────────────────────────────────────────────────
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/app_models.dart';

// Top-level handler required by FCM for background messages
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Firebase is already initialized by this point
  // You can handle background messages here if needed
}

class NotificationService {
  final _fcm = FirebaseMessaging.instance;
  final _db  = FirebaseFirestore.instance;

  final _localNotif = FlutterLocalNotificationsPlugin();

  // ── Initialize ────────────────────────────────────────────────────────────
  Future<void> init() async {
    // Request permission (iOS / Android 13+)
    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Local notifications channel (Android)
    const androidChannel = AndroidNotificationChannel(
      'bidforge_channel',
      'BidForge Notifications',
      description: 'Auction results and bid alerts',
      importance: Importance.high,
    );

    final androidPlugin =
        _localNotif.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(androidChannel);

    await _localNotif.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );

    // Foreground message handler
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Background handler registration
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  // ── Get & return FCM token ─────────────────────────────────────────────────
  Future<String?> getToken() => _fcm.getToken();

  // ── Subscribe to topic (e.g. per-product updates) ─────────────────────────
  Future<void> subscribeToProduct(String productId) =>
      _fcm.subscribeToTopic('product_$productId');

  Future<void> unsubscribeFromProduct(String productId) =>
      _fcm.unsubscribeFromTopic('product_$productId');

  // ── Show local notification for foreground messages ────────────────────────
  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _localNotif.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'bidforge_channel',
          'BidForge Notifications',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
    );
  }

  // ── Save in-app notification to Firestore ─────────────────────────────────
  Future<void> saveNotification({
    required String userId,
    required String title,
    required String body,
    String? productId,
  }) async {
    final notif = AppNotification(
      id: '',
      userId: userId,
      title: title,
      body: body,
      productId: productId,
      isRead: false,
      timestamp: DateTime.now(),
    );
    await _db.collection('notifications').add(notif.toMap());
  }

  // ── Stream of notifications for current user ──────────────────────────────
  Stream<List<AppNotification>> watchNotifications(String userId) {
    return _db
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) =>
                AppNotification.fromMap(d.data(), d.id))
            .toList());
  }

  // ── Mark notification as read ─────────────────────────────────────────────
  Future<void> markRead(String notifId) async {
    await _db
        .collection('notifications')
        .doc(notifId)
        .update({'isRead': true});
  }

  // ── Unread count stream ───────────────────────────────────────────────────
  Stream<int> watchUnreadCount(String userId) {
    return _db
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snap) => snap.docs.length);
  }
}
