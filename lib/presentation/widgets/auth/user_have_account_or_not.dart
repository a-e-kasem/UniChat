import 'package:flutter/material.dart';
import 'package:UniChat/presentation/screens/auth/register_screen.dart';

class UserHaveAccountOrNot extends StatelessWidget {
  const UserHaveAccountOrNot({super.key, required this.nextPage});

  final String nextPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        nextPage == 'Login'
            ?  Text('Already have an account?')
            :  Text('Don\'t have an account?'),
        const SizedBox(width: 5),
        GestureDetector(
          onTap: () {
            if (nextPage == 'Login') {
              Navigator.pop(context);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => RegisterScreen()),
              );
            }
          },
          child: Text(
            nextPage,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
