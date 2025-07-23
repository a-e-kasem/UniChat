// app/routes/app_routes.dart
import 'package:flutter/material.dart';
import 'package:uni_chat/screens/admins/admin_screen.dart';
import 'package:uni_chat/screens/auth/login_screen.dart';
import 'package:uni_chat/screens/auth/register_screen.dart';
import 'package:uni_chat/screens/chat/chat_screen.dart';
import 'package:uni_chat/screens/home/home_screen.dart';
import 'package:uni_chat/screens/splash/splash_screen.dart';
import 'package:uni_chat/widgets/admin/screens/users_admin_controle_screen.dart';
import 'package:uni_chat/widgets/navigation/build_pages.dart';

class AppRoutes {
  static const String splash = SplashScreen.id;
  static const String login = LoginScreen.id;
  static const String register = RegisterScreen.id;
  static const String home = HomeScreen.id;
  static const String buildPages = BuildPages.id;
  static const String chat = ChatScreen.id;
  static const String admin = AdminScreen.id;
  static const String usersAdminControl = UsersAdminControlScreen.id;

  static final Map<String, WidgetBuilder> routes = {
    splash: (_) => SplashScreen(),
    login: (_) => LoginScreen(),
    register: (_) => RegisterScreen(),
    home: (_) => HomeScreen(),
    buildPages: (_) => BuildPages(),
    chat: (_) => ChatScreen(group: {}),
    admin: (_) => AdminScreen(),
    usersAdminControl: (_) => UsersAdminControlScreen(),
  };
}
