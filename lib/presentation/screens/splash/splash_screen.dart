import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:UniChat/logic/cubits/home_cubit/home_cubit.dart';
import 'package:UniChat/presentation/screens/admins/admin_screen.dart';
import 'package:UniChat/presentation/screens/auth/login_screen.dart';
import 'package:UniChat/presentation/widgets/navigation/build_pages.dart';

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
    Future.delayed(const Duration(seconds: 2), checkAuthState);
  }

  void checkAuthState() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Navigator.pushReplacementNamed(context, LoginScreen.id);
    } else if (user.email!.contains('admin')) {
      Navigator.pushReplacementNamed(context, AdminScreen.id);
    } else {
      context.read<HomeCubit>().getUserGroups();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: BlocListener<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is HomeGroupsLoaded || state is HomeGroupsError) {
            Navigator.pushReplacementNamed(context, BuildPages.id);
          }
        },
        child: Center(
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
      ),
    );
  }
}
