import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:uni_chat/presentation/app/app_widget.dart';
import 'package:uni_chat/logic/register_cubit/register_cubit.dart';
import 'package:uni_chat/logic/replay_cubit/replay_message_cubit.dart';
import 'package:uni_chat/logic/user_cubit/user_cubit.dart';
import 'package:uni_chat/data/models/mode_model.dart';
import 'package:uni_chat/data/models/selected_Index.dart';
import 'core/config/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ReplayMessageCubit()),
        BlocProvider(create: (_) => RegisterCubit()),
        BlocProvider(create: (_) => UserCubit()),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ModeModel()),
          ChangeNotifierProvider(create: (_) => SelectedIndex()),
        ],
        child: UniChat(),
      ),
    ),
  );
}
