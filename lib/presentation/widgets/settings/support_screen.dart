import 'package:UniChat/data/core/consts/consts.dart';
import 'package:UniChat/logic/cubits/notification_cubit/notification_cubit.dart';
import 'package:UniChat/presentation/widgets/settings/firebase_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupportScreen extends StatelessWidget {
  SupportScreen({super.key});
  final TextEditingController messageController = TextEditingController();
  Future<void> sendNotification(String message) async {
    final serviceAccountPath = 'service-account.json';
    final projectId = 'uni-chat-69d59';
    final sender = FcmSender(serviceAccountPath, projectId);
    await sender.init();

    await sender.sendNotification(
      deviceToken:
          'eam62CACQye8qGIvJ0jvNT:APA91bGblGoADPcvKLC-5xUCNBkPX7M3eeS6taPQAVpNhZTtsLE4jWPnlVtr0dC_oWjgc84pG0nz__Y4rob6R_tAlIjIQRzD5y6M_rtzt3S4hu_tP3F5jfE',
      title: 'New Support Message',
      body: message,
      data: {'click_action': 'FLUTTER_NOTIFICATION_CLICK'},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Support')),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: TextField(
                  controller: messageController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your message...',
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final message = messageController.text.trim();

              if (message.isEmpty) {
                showSnackBarError(context, 'Please enter a message');
                return;
              }

              try {
                await BlocProvider.of<NotificationCubit>(
                  context,
                ).sendSupportMessage(message);

                messageController.clear();
                showSnackBarSuccess(context, 'Message sent successfully');
              } catch (e) {
                showSnackBarError(context, 'Error sending message');
              }
            },

            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Colors.green,
            ),
            child: const Text(
              'Send',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
