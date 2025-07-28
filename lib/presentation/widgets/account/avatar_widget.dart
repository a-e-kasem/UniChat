import 'package:UniChat/logic/cubits/account_cubit/account_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountCubit, AccountState>(
      builder: (context, state) {
        final url = BlocProvider.of<AccountCubit>(context).user?.photoURL;

        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
          child: (url != null && url.startsWith('http'))
              ? CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.black,
                  backgroundImage: NetworkImage(url),
                )
              : const CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.black12,
                  child: Icon(
                    FontAwesomeIcons.circleUser,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
        );
      },
    );
  }
}
