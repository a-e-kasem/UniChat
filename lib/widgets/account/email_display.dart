import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailDisplay extends StatelessWidget {
  const EmailDisplay({super.key, required this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    return Text(
      user?.email ?? '',
      style: const TextStyle(fontSize: 24, color: Colors.blueGrey),
    );
  }
}
