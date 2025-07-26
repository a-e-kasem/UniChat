import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:UniChat/core/routes/app_routes.dart';
import 'package:UniChat/core/themes/app_theme.dart';
import 'package:UniChat/logic/mode_cubit/mode_cubit.dart';
import 'package:UniChat/presentation/screens/splash/splash_screen.dart';

class UniChat extends StatelessWidget {
  const UniChat({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ModeCubit, ModeState>(
      listener: (context, state) {
        if (state is ModeDark) {
          // =======
        } else {
          // =======
        }
      },
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'UniChat',
          routes: AppRoutes.routes,

          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: BlocProvider.of<ModeCubit>(context).isDark
              ? ThemeMode.dark
              : ThemeMode.light,
          initialRoute: SplashScreen.id,
        );
      },
    );
  }
}
