// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:UniChat/presentation/widgets/account/account_screen_app_bar.dart';
import 'package:UniChat/presentation/widgets/account/user_image_display.dart';
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
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
