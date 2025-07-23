// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_chat/core/consts/consts.dart';
import 'package:uni_chat/models/user_model.dart';
import 'package:uni_chat/widgets/account/change_image_button.dart';
import '../../widgets/account/avatar_widget.dart';
import '../../widgets/account/editable_name_widget.dart';
import '../../widgets/account/email_display.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key});
  static const String id = 'AccountScreen';

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool isEdit = false;
  final TextEditingController nameController = TextEditingController();

  User? get user => FirebaseAuth.instance.currentUser;
  final ValueNotifier<String?> _photoUrlNotifier = ValueNotifier(
    FirebaseAuth.instance.currentUser?.photoURL,
  );

  @override
  void initState() {
    super.initState();
    nameController.text = user?.displayName ?? '';
  }

  Future<void> updateDisplayName() async {
    final newName = nameController.text.trim();
    if (newName.isEmpty || newName == user?.displayName) return;

    try {
      await user!.updateDisplayName(newName);
      await user!.reload();

      final updatedUser = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(updatedUser!.uid)
          .update({'name': newName});
    } catch (e) {
      showSnackBarError(context, 'Failed to update name: ${e.toString()}');
    }

    FocusScope.of(context).unfocus();
    setState(() => isEdit = false);

    Provider.of<UserModel>(context, listen: false).setUserName(newName);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Name updated to "$newName"'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Account'),

        centerTitle: true,
        toolbarHeight: 80,
      ),
      body: Center(
        child: Column(
          children: [
            const Spacer(flex: 1),
            ChangeNotifierProvider<ValueNotifier<String?>>.value(
              value: _photoUrlNotifier,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 35),
                  const AvatarWidget(),
                  const SizedBox(width: 10),
                  ChangeImageButton(notifier: _photoUrlNotifier),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: EditableNameWidget(
                isEdit: isEdit,
                controller: nameController,
                displayName: user?.displayName,
                onEditPressed: () => setState(() => isEdit = true),
                onSubmit: updateDisplayName,
              ),
            ),
            const SizedBox(height: 10),
            EmailDisplay(user: user),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
