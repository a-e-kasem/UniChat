import 'package:UniChat/data/services/api/cloudinary_service.dart';
import 'package:UniChat/logic/cubits/user_cubit/user_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit() : super(AccountInitial());

  User? get user => FirebaseAuth.instance.currentUser;

  // Part User Image
  void startUpdateName() {
    emit(StartUpdateUserName());
  }

  Future<void> updateDisplayName(String newName, BuildContext context) async {
    emit(StartUpdateUserName());

    if (newName.trim().isEmpty || newName.trim() == user?.displayName?.trim()) {
      emit(UpdateUserNameFailed());
      return;
    }

    try {
      await user!.updateDisplayName(newName.trim());
      await user!.reload();

      final updatedUser = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(updatedUser!.uid)
          .update({'name': newName.trim()});

      FocusScope.of(context).unfocus();

      final userCubit = BlocProvider.of<UserCubit>(context);
      userCubit.setUserName(newName.trim());

      emit(UpdateUserNameSuccess());
    } catch (e) {
      debugPrint('Error updating display name: $e');
      emit(UpdateUserNameFailed());
    }
  }

  // Part User Image
  void startUpdateImage() {
    emit(StartUpdateUserImage());
  }

  Future<void> updateImageBySource(
    BuildContext context,
    ImageSource source,
  ) async {
    try {
      emit(StartUpdateUserImage());

      final user = FirebaseAuth.instance.currentUser;
      final imageUrl = await CloudinaryService.uploadImage(source: source);

      if (imageUrl == null || user == null) {
        emit(UpdateUserImageFailed());
        return;
      }

      await user.updatePhotoURL(imageUrl);

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {'photoUrl': imageUrl},
      );

      await user.reload();

      emit(UpdateUserImageSuccess());
    } catch (e) {
      debugPrint("Error updating image: $e");
      emit(UpdateUserImageFailed());
    }
  }
}
