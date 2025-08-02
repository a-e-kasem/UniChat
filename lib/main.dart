import 'package:UniChat/data/core/config/firebase_options.dart';
import 'package:UniChat/logic/cubits/account_cubit/account_cubit.dart';
import 'package:UniChat/logic/cubits/admin_groups_cubit/admin_groups_cubit.dart';
import 'package:UniChat/logic/cubits/chat_cubit/chat_cubit.dart';
import 'package:UniChat/logic/cubits/home_cubit/home_cubit.dart';
import 'package:UniChat/logic/cubits/notification_cubit/notification_cubit.dart';
import 'package:UniChat/presentation/widgets/settings/firebase_api.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:UniChat/logic/cubits/mode_cubit/mode_cubit.dart';
import 'package:UniChat/logic/cubits/swich_pages_cubit/swich_pages_cubit.dart';
import 'package:UniChat/presentation/app/app_widget.dart';
import 'package:UniChat/logic/cubits/register_cubit/register_cubit.dart';
import 'package:UniChat/logic/cubits/replay_cubit/replay_message_cubit.dart';
import 'package:UniChat/logic/cubits/user_cubit/user_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotification();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ReplayMessageCubit()),
        BlocProvider(create: (_) => RegisterCubit()),
        BlocProvider(create: (_) => UserCubit()),
        BlocProvider(create: (_) => SwichPagesCubit()),
        BlocProvider(create: (_) => ModeCubit()),
        BlocProvider(create: (_) => AccountCubit()),
        BlocProvider(create: (_) => HomeCubit()),
        BlocProvider(create: (_) => ChatCubit()),
        BlocProvider(create: (_) => AdminGroupsCubit()),
        BlocProvider(create: (_) => NotificationCubit()),
      ],

      child: UniChat(),
    ),
  );
}
