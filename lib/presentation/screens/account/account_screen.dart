// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:UniChat/presentation/screens/auth/login_screen.dart';
import 'package:UniChat/presentation/widgets/account/account_screen_app_bar.dart';
import 'package:UniChat/presentation/widgets/account/user_image_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../widgets/account/user_display_name.dart';
import '../../widgets/account/email_display.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});
  static const String id = 'AccountScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AccountScreenAppBar(),

      body: Center(
        child: Column(
          children: [
            const Spacer(flex: 1),
            UserImageDisplay(),
            const SizedBox(height: 20),
            UserDisplayName(),
            const SizedBox(height: 10),
            EmailDisplay(),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, LoginScreen.id);
                }
              },
              child: Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout, size: 30, color: Colors.white),
                    const SizedBox(width: 10),
                    const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
