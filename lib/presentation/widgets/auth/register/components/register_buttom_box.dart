import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:UniChat/data/core/consts/consts.dart';

// ignore: must_be_immutable
class RegisterButtonBox extends StatelessWidget {
  RegisterButtonBox({
    super.key,
    required this.id,
    required this.email,
    required this.name,
    required this.password,
    required this.confirmPassword,
    required this.formKey,
  });

  final TextEditingController name;
  final TextEditingController id;
  final TextEditingController email;
  final TextEditingController password;
  final TextEditingController confirmPassword;
  final GlobalKey<FormState> formKey;

  String role = 'student';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () async {
        if (formKey.currentState!.validate()) {
          // if (!email.text.trim().endsWith(
          //   '.edu.eg',
          // )) {
          //   showSnackBarError(
          //     context,
          //     'Email must end with .edu.eg Domain',
          //   );
          //   return;
          // }

          // for test=================================<<
          if (!email.text.trim().endsWith('.edu.eg') &&
              !email.text.trim().endsWith('@gmail.com')) {
            showSnackBarError(
              context,
              'Email must be a Google email or your University email',
            );
            return;
          }

          if (password.text != confirmPassword.text) {
            showSnackBarError(context, 'Passwords do not match.');
            return;
          }
          showLoadingDialog(context);
          try {
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: email.text.trim(),
              password: password.text.trim(),
            );

            final user = FirebaseAuth.instance.currentUser;

            if (user != null) {
              // Create user document in Firestore
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .set({
                    'uid': id.text.trim(),
                    'name': name.text.trim(),
                    'email': email.text.trim(),
                    'role': role,
                    'createdAt': Timestamp.now(),
                  });

              // update display name
              await user.updateDisplayName(name.text.trim());
              await user.reload();

              // send email verification
              await user.sendEmailVerification();

              await FirebaseAuth.instance.signOut();
              hideLoadingDialog(context);
              Navigator.pop(context);
            }

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'The activation link has been sent to your email.',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.blueGrey,
                  content: Text(
                    'You must confirm the first email 📧',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              );
            }
          } on FirebaseAuthException catch (e) {
            if (FirebaseAuth.instance.currentUser != null) {
              await FirebaseAuth.instance.signOut();
            }
            if (context.mounted) {
              hideLoadingDialog(context);
            }
            if (e.code == 'email-already-in-use') {
              log('The email is already in use.');
              showSnackBarError(context, 'The email is already in use.');
            } else if (e.code == 'invalid-email') {
              log('The email address is not valid.');
              showSnackBarError(context, 'The email address is not valid.');
            } else if (e.code == 'weak-password') {
              log('The password provided is too weak.');
              showSnackBarError(context, 'The password provided is too weak.');
            } else {
              log('error: ${e.code}');
              showSnackBarError(context, 'error: ${e.code}');
            }
          } catch (e) {
            hideLoadingDialog(context);
            if (FirebaseAuth.instance.currentUser != null) {
              await FirebaseAuth.instance.signOut();
            }
            log('General Error: ${e.toString()}');
            showSnackBarError(context, 'Error: ${e.toString()}');
          }
        }
      },
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: isDark ? Colors.white : Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'Sign Up',
          style: GoogleFonts.inter(
            color: isDark ? Colors.black : Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
