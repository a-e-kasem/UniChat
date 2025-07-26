import 'package:flutter/material.dart';
import 'package:UniChat/presentation/widgets/auth/register/components/selecter_role.dart';
import 'package:UniChat/presentation/widgets/auth/text_field_in_form.dart';
import 'package:UniChat/presentation/widgets/auth/login/components/login_buttom_box.dart';
import 'package:UniChat/presentation/widgets/auth/register/components/register_buttom_box.dart';
import 'package:UniChat/presentation/widgets/auth/user_have_account_or_not.dart';

// ignore: must_be_immutable
class LogInForm extends StatefulWidget {
  const LogInForm({super.key});

  @override
  State<LogInForm> createState() => _LogInFormState();
}

class _LogInFormState extends State<LogInForm> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      flex: 3,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.black : Colors.white,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(60)),
        ),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 40),
                MyTextFormField(
                  controller: email,
                  obscureText: false,
                  labelText: 'Email:',
                  hintText: 'Enter your email',
                  validatorText: 'Please enter your email',
                ),
                const SizedBox(height: 15),
                MyTextFormField(
                  controller: password,
                  obscureText: true,
                  labelText: 'Password:',
                  hintText: 'Enter your password',
                  validatorText: 'Please enter your password',
                ),
                const SizedBox(height: 20),
                LoginButtonBox(
                  email: email,
                  password: password,
                  formKey: _formKey,
                ),
                const SizedBox(height: 10),
                const UserHaveAccountOrNot(nextPage: 'Sign Up'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController id = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController role = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(60)),
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: isDark ? Colors.black : Colors.white),
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                const SizedBox(height: 30),
                MyTextFormField(
                  controller: id,
                  obscureText: false,
                  labelText: 'ID:',
                  hintText: 'Enter your ID',
                  validatorText: 'Please enter your ID',
                ),
                const SizedBox(height: 15),
                MyTextFormField(
                  controller: email,
                  obscureText: false,
                  labelText: 'Email:',
                  hintText: 'Enter your email',
                  validatorText: 'Please enter your email',
                ),
                const SizedBox(height: 15),
                SelecterRole(role: role),
                const SizedBox(height: 15),
                MyTextFormField(
                  controller: password,
                  obscureText: true,
                  labelText: 'Password:',
                  hintText: 'Enter your password',
                  validatorText: 'Please enter your password',
                ),
                const SizedBox(height: 15),
                MyTextFormField(
                  controller: confirmPassword,
                  obscureText: true,
                  labelText: 'Confirm Password:',
                  hintText: 'Enter your confirm password',
                  validatorText: 'Please enter your confirm password',
                ),
                const SizedBox(height: 20),
                RegisterButtonBox(
                  id: id,
                  email: email,
                  role: role,
                  password: password,
                  confirmPassword: confirmPassword,
                  formKey: _formKey,
                ),
                const SizedBox(height: 10),
                UserHaveAccountOrNot(nextPage: 'Login'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
