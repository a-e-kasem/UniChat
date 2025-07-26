// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uni_chat/core/consts/consts.dart';
import 'package:uni_chat/data/services/api/cloudinary_service.dart';

class ChangeImageButton extends StatelessWidget {
  final ValueNotifier<String?> notifier;

  const ChangeImageButton({super.key, required this.notifier});

  void UpdateImageBySource (context, ImageSource source) async {

    final user = FirebaseAuth.instance.currentUser;
        final imageUrl = await CloudinaryService.uploadImage(
          source: source,
        );

        if (imageUrl == null || user == null) return;

        try {
          await user.updatePhotoURL(imageUrl);
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({'photoUrl': imageUrl});

          notifier.value = imageUrl;

          showSnackBarSuccess(context, 'Profile picture updated!');
        } catch (e) {
          showSnackBarError(context, 'Failed to update image: ${e.toString()}');
        }
  }
  
  void showImagePicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                UpdateImageBySource(context, ImageSource.camera);

              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                UpdateImageBySource(context, ImageSource.gallery);

              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        showImagePicker(context);
      },
      child: const Icon(FontAwesomeIcons.camera, size: 25,color: Colors.grey),
    );
  }
}
