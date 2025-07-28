import 'package:UniChat/data/core/consts/consts.dart';
import 'package:UniChat/logic/cubits/account_cubit/account_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDisplayName extends StatefulWidget {
  const UserDisplayName({super.key});

  @override
  State<UserDisplayName> createState() => _UserDisplayNameState();
}

class _UserDisplayNameState extends State<UserDisplayName> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountCubit, AccountState>(
      listener: (context, state) {
        if (state is UpdateUserNameSuccess) {
          showSnackBarSuccess(context, 'Name updated successfully');
          controller.clear();
        } else if (state is UpdateUserNameFailed) {
          showSnackBarError(context, 'Failed to update name');
        }
      },
      builder: (context, state) {
        final blocProvider = context.watch<AccountCubit>();
        final displayName = blocProvider.user?.displayName?.trim() ?? '';

        if (state is StartUpdateUserName) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    autofocus: true,
                    onSubmitted: (_) =>
                        blocProvider.updateDisplayName(controller.text, context),
                    decoration: InputDecoration(
                      hintText: 'Enter your name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.check, color: Colors.green),
                  onPressed: () {
                    blocProvider.updateDisplayName(controller.text, context);
                  },
                ),
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    displayName.isNotEmpty ? displayName : 'No Name',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.grey),
                  onPressed: () {
                    controller.text = displayName;
                    blocProvider.startUpdateName();
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

