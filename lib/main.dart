import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:UniChat/logic/mode_cubit/mode_cubit.dart';
import 'package:UniChat/logic/swich_pages_cubit/swich_pages_cubit.dart';
import 'package:UniChat/presentation/app/app_widget.dart';
import 'package:UniChat/logic/register_cubit/register_cubit.dart';
import 'package:UniChat/logic/replay_cubit/replay_message_cubit.dart';
import 'package:UniChat/logic/user_cubit/user_cubit.dart';
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
        BlocProvider(create: (_) => SwichPagesCubit()),
        BlocProvider(create: (_) => ModeCubit()),
      ],
      
        child: UniChat(),
      
    ),
  );
}
