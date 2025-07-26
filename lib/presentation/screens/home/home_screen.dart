import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:UniChat/logic/mode_cubit/mode_cubit.dart';
import 'package:UniChat/presentation/widgets/home/join_to_group_button.dart';
import 'package:UniChat/presentation/widgets/home/provider_state.dart';
import 'package:UniChat/presentation/screens/auth/login_screen.dart';
import 'package:UniChat/presentation/widgets/home/body_info.dart';
import 'package:UniChat/presentation/widgets/home/image_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String id = 'HomeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return ChangeNotifierProvider(
      create: (context) => ProviderState(),
      child: Scaffold(
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
            JoinToGroupButton(userId: user.uid, userName: user.displayName),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: () {
                BlocProvider.of<ModeCubit>(context).toggleMode();
              },
              child: Icon(
                isDark ? Icons.light_mode : Icons.dark_mode,
                size: 30,
              ),
            ),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, LoginScreen.id);
                }
              },
              child: Icon(Icons.logout, size: 30),
            ),
            const SizedBox(width: 5),
          ],
        ),
        body: BodyInfo(),
      ),
    );
  }
}
