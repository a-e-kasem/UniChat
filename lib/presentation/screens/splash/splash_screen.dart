import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uni_chat/presentation/screens/admins/admin_screen.dart';
import 'package:uni_chat/presentation/screens/auth/login_screen.dart';
import 'package:uni_chat/presentation/widgets/navigation/build_pages.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String id = 'SplashScreen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), checkAuthState);
  }

  void checkAuthState() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pushReplacementNamed(context, LoginScreen.id);
    } else {
      if (user.email == 'admin@admin.com') {
        Navigator.pushReplacementNamed(context, AdminScreen.id);
      } else {
        Navigator.pushReplacementNamed(context, BuildPages.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              isDark
                  ? 'assets/logo/logo_white.png'
                  : 'assets/logo/logo_black.png',
              width: 200,
            ),
            const SizedBox(height: 20),
            Text(
              'Welcome to UniChat',
              style: TextStyle(
                fontSize: 18,
                color: isDark ? Colors.grey[300] : Colors.grey[800],
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
