import 'package:UniChat/data/core/consts/consts.dart';
import 'package:UniChat/logic/cubits/user_cubit/user_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DisplayName {
  TextEditingController nameController;
  BuildContext context;
  DisplayName(this.nameController, this.context);

  Future<void> updateDisplayName() async {
    final user = FirebaseAuth.instance.currentUser;
    final newName = nameController.text.trim();
    if (newName.isEmpty || newName == user?.displayName) return;

    try {
      await user!.updateDisplayName(newName);
      await user.reload();

      final updatedUser = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(updatedUser!.uid)
          .update({'name': newName});
    } catch (e) {
      showSnackBarError(
        context,
        'Failed to update name: ${e.toString()}',
      );
    }

    FocusScope.of(context).unfocus();

    final userCubit = BlocProvider.of<UserCubit>(context);
    userCubit.setUserName(newName);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Name updated to "$newName"'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
