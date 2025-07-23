import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_chat/routes/app_routes.dart';
import 'package:uni_chat/core/themes/app_theme.dart';
import 'package:uni_chat/models/mode_model.dart';
import 'package:uni_chat/screens/splash/splash_screen.dart';

class UniChat extends StatelessWidget {
  const UniChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ModeModel>(
      builder: (context, modeModel, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'UniChat',
          routes: AppRoutes.routes,

          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: modeModel.mode == Brightness.dark
              ? ThemeMode.dark
              : ThemeMode.light,
          initialRoute: SplashScreen.id,
        );
      },
    );
  }
}
