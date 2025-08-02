import 'dart:developer';

import 'package:UniChat/presentation/widgets/admin/screens/groups_admin_controle_screen.dart';
import 'package:UniChat/presentation/widgets/admin/screens/university_admin_controle_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:UniChat/presentation/screens/auth/login_screen.dart';
import 'package:UniChat/presentation/widgets/admin/screens/users_admin_controle_screen.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});
  static const String id = 'AdminScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () async {
            final adminDoc = await FirebaseFirestore.instance
                .collection('admins')
                .doc('admin@test.com')
                .get();
            final targetFCMToken = adminDoc.data()?['fcmToken'];

            if (targetFCMToken != null) {
              log(targetFCMToken);
            }
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.send),
          ),
        ),

        title: const Text('Admin Screen'),
        centerTitle: true,

        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, LoginScreen.id);
              }
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, UsersAdminControlScreen.id);
              },
              child: Container(
                margin: const EdgeInsets.all(20.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: Colors.blueAccent,
                ),
                child: Text(
                  'Users',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, GroupsAdminControleScreen.id);
              },
              child: Container(
                margin: const EdgeInsets.all(20.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: Colors.deepPurple,
                ),
                child: Text(
                  'Groups',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, UniversityAdminControleScreen.id);
              },
              child: Container(
                margin: const EdgeInsets.all(20.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: Colors.deepOrange,
                ),
                child: Text(
                  'University',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
