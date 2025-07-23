import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:uni_chat/app/app_widget.dart';
import 'package:uni_chat/models/messageRegister.dart';
import 'package:uni_chat/models/mode_model.dart';
import 'package:uni_chat/models/selected_Index.dart';
import 'package:uni_chat/models/user_model.dart';
import 'package:uni_chat/providers/chat_provider.dart';
import 'config/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserModel()),
        ChangeNotifierProvider(create: (context) => Messageregister()),
        ChangeNotifierProvider(create: (context) => ModeModel()),
        ChangeNotifierProvider(create: (context) => SelectedIndex()),
        ChangeNotifierProvider<ReplyProvider>(
          create: (context) => ReplyProvider(),
        ),
      ],
      child: UniChat(),
    ),
  );
}
