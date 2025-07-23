import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.validatorText,
    required this.controller,
    required this.obscureText,
  });

  final String labelText;
  final String hintText;
  final String validatorText;
  final TextEditingController controller;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 2),
          TextFormField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              hintText: hintText,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return validatorText;
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
