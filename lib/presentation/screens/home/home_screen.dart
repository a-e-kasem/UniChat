
import 'package:UniChat/presentation/widgets/home/doctor_create_group_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:UniChat/presentation/widgets/home/join_to_group_button.dart';
import 'package:UniChat/presentation/widgets/home/body_info.dart';
import 'package:UniChat/presentation/widgets/home/image_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String id = 'HomeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userRole;

  @override
  void initState() {
    super.initState();
    loadUseruserRole();
    
  }



  Future<void> loadUseruserRole() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();

    if (mounted) {
      setState(() {
        userRole = doc.data()?['userRole'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        leading: ImageBar(),
        leadingWidth: 70,
        shadowColor:
            Theme.of(context).bottomNavigationBarTheme.selectedItemColor ??
            Colors.grey,
        title: const Text(
          'UniChat',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        toolbarHeight: 80,
        actions: [
          userRole == 'doctor'
              ? DoctorCreateGroupButton()
              : JoinToGroupButton(userId: user.uid, userName: user.displayName),
          const SizedBox(width: 5),
        ],
      ),
      body: BodyInfo(userRole: userRole ?? 'student'),
    );
  }
}
