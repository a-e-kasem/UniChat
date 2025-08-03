import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  void receiveNotification({required String title, required String body}) {
    emit(NotificationReceived(title: title, body: body));
  }

  void clearNotification() {
    emit(NotificationInitial());
  }

  Future<void> sendSupportMessage(String message) async {
    try {
      await FirebaseFirestore.instance.collection('supportMessage').add({
        'message': message,
        'timestamp': Timestamp.now(),
      });

      await _sendPushNotification(
        title: 'Support Message',
        body: message,
      );

      receiveNotification(title: 'New Support Message', body: message);
    } catch (e) {
      print('❌ Error in sendSupportMessage: $e');
    }
  }

  Future<void> _sendPushNotification({
    required String title,
    required String body,
  }) async {
    const String serverKey = 'YOUR_FIREBASE_SERVER_KEY';
    const String targetFCMToken = 'ADMIN_DEVICE_FCM_TOKEN'; 

    final url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode({
        "to": targetFCMToken,
        "notification": {
          "title": title,
          "body": body,
        },
        "data": {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
        }
      }),
    );

    print('✅ FCM status: ${response.statusCode}');
    print('📦 FCM response: ${response.body}');
  }
}
