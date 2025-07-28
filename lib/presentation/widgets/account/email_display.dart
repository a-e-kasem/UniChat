import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailDisplay extends StatelessWidget {
  EmailDisplay({super.key});

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Text(
      user?.email ?? '',
      style: const TextStyle(fontSize: 24, color: Colors.blueGrey),
    );
  }
}
