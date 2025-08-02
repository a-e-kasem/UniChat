import 'package:UniChat/presentation/widgets/settings/mode_switch_button.dart';
import 'package:UniChat/presentation/widgets/settings/show_support_message_button.dart';
import 'package:UniChat/presentation/widgets/settings/support_screen_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final canSupport = user?.email != 'a.ali2672@su.edu.eg';
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Settings Screen',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          Center(child: ModeSwitchButton()),

          const SizedBox(height: 20),
          Center(
            child: canSupport
                ? SupportScreenButton()
                : ShowSupportMessageButton(),
          ),
         
        ],
      ),
    );
  }
}
