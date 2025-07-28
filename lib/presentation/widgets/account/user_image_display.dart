import 'package:UniChat/logic/cubits/account_cubit/account_cubit.dart';
import 'package:UniChat/presentation/widgets/account/avatar_widget.dart';
import 'package:UniChat/data/core/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class UserImageDisplay extends StatelessWidget {
  const UserImageDisplay({super.key});

  void showImagePicker(BuildContext context) {
    final blocProvider = BlocProvider.of<AccountCubit>(context);
    FocusScope.of(context).unfocus();

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
                blocProvider.updateImageBySource(context, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                blocProvider.updateImageBySource(context, ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountCubit, AccountState>(
      listener: (context, state) {
        if (state is UpdateUserImageSuccess) {
          showSnackBarSuccess(context, 'Image updated successfully');
        } else if (state is UpdateUserImageFailed) {
          showSnackBarError(context, 'Failed to update image');
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              const AvatarWidget(),
              Positioned(
                bottom: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () => showImagePicker(context),
                  child: const CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white,
                    child: Icon(
                      FontAwesomeIcons.camera,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
