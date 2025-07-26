import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelecterRole extends StatefulWidget {
  const SelecterRole({super.key, required this.role});
  final TextEditingController role;

  @override
  State<SelecterRole> createState() => _SelecterRoleState();
}


class _SelecterRoleState extends State<SelecterRole> {
  String? selectedRole;

  @override
  void initState() {
    super.initState();
    if (widget.role.text.isEmpty) {
      selectedRole = 'student'; 
      widget.role.text = selectedRole!;
    } else {
      selectedRole = widget.role.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Role:',
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          DropdownButtonFormField<String>(
            isExpanded: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            value: selectedRole,
            items: const [
              DropdownMenuItem(value: 'student', child: Text('Student')),
              DropdownMenuItem(value: 'teacher', child: Text('Teacher')),
            ],
            onChanged: (value) {
              setState(() {
                selectedRole = value!;
                widget.role.text = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select your role';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
