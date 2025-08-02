// app/routes/app_routes.dart
import 'package:UniChat/data/models/group_model.dart';
import 'package:UniChat/presentation/widgets/admin/components/create_group_screen.dart';
import 'package:UniChat/presentation/widgets/admin/screens/groups_admin_controle_screen.dart';
import 'package:UniChat/presentation/widgets/admin/screens/university_admin_controle_screen.dart';
import 'package:flutter/material.dart';
import 'package:UniChat/presentation/screens/admins/admin_screen.dart';
import 'package:UniChat/presentation/screens/auth/login_screen.dart';
import 'package:UniChat/presentation/screens/auth/register_screen.dart';
import 'package:UniChat/presentation/screens/chat/chat_screen.dart';
import 'package:UniChat/presentation/screens/home/home_screen.dart';
import 'package:UniChat/presentation/screens/splash/splash_screen.dart';
import 'package:UniChat/presentation/widgets/admin/screens/users_admin_controle_screen.dart';
import 'package:UniChat/presentation/widgets/navigation/build_pages.dart';

class AppRoutes {
  static const String splash = SplashScreen.id;
  static const String login = LoginScreen.id;
  static const String register = RegisterScreen.id;
  static const String home = HomeScreen.id;
  static const String buildPages = BuildPages.id;
  static const String chat = ChatScreen.id;
  static const String admin = AdminScreen.id;
  static const String usersAdminControl = UsersAdminControlScreen.id;
  static const String groupsAdminControle = GroupsAdminControleScreen.id;
  static const String createGroup = CreateGroupScreen.id;
  static const String universityAdminControl = UniversityAdminControleScreen.id;


  static final Map<String, WidgetBuilder> routes = {
    splash: (_) => SplashScreen(),
    login: (_) => LoginScreen(),
    register: (_) => RegisterScreen(),
    home: (_) => HomeScreen(),
    buildPages: (_) => BuildPages(),
    chat: (_) => ChatScreen(
      group: GroupModel(id: '', name: '', messages: [], members: []),
    ),
    admin: (_) => AdminScreen(),
    usersAdminControl: (_) => UsersAdminControlScreen(),
    groupsAdminControle: (_) => GroupsAdminControleScreen(),
    createGroup: (_) => CreateGroupScreen(),
    universityAdminControl: (_) => UniversityAdminControleScreen(),
 
  };
}
