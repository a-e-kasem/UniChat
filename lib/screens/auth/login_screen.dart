import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:uni_chat/models/mode_model.dart';
import 'package:uni_chat/widgets/auth/login/components/logo_image_show.dart';
import 'package:uni_chat/widgets/auth/signin_or_signup_form.dart';
import 'package:uni_chat/models/messageRegister.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String id = 'LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? email;
  String? password;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Consumer<Messageregister>(
      builder: (context, messageRegister, child) {
        if (messageRegister.message != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green,
                content: Text(
                  messageRegister.message!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
            messageRegister.clear();
          });
        }

        return ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Scaffold(
            backgroundColor: isDark ? Colors.white : Colors.black,
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Container(
                decoration: BoxDecoration(),
                child: Column(
                  children: [
                    SafeArea(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                Provider.of<ModeModel>(
                                  context,
                                  listen: false,
                                ).toggleMode();
                              });
                            },
                            icon: Icon(
                              isDark ? Icons.light_mode : Icons.dark_mode,
                              color: isDark ? Colors.black : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // To show logo image
                    LogoImageShow(isDark: isDark),

                    // Form to login user
                    LogInForm(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}
