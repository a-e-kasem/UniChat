import 'package:flutter/material.dart';

class LogoImageShow extends StatelessWidget {
  const LogoImageShow({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Center(
        child: Image.asset(
          isDark ? 'assets/logo/logo_black.png' : 'assets/logo/logo_white.png',
          width: 200,
        ),
      ),
    );
  }
}
