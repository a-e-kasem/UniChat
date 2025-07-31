import 'package:UniChat/presentation/widgets/admin/components/create_group_screen.dart';
import 'package:flutter/material.dart';

class DoctorCreateGroupButton extends StatefulWidget {
  const DoctorCreateGroupButton({super.key});

  @override
  State<DoctorCreateGroupButton> createState() =>
      _DoctorCreateGroupButtonState();
}

class _DoctorCreateGroupButtonState extends State<DoctorCreateGroupButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add, color: Colors.blue, size: 30),
      onPressed: () async {
        CreateGroupScreen.roleCall = 'doctor';
        await Navigator.pushNamed(context, CreateGroupScreen.id);
      },
    );
  }
}
