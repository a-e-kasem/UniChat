import 'package:UniChat/presentation/widgets/settings/show_support_message_screen.dart';
import 'package:flutter/material.dart';

class ShowSupportMessageButton extends StatelessWidget {
  const ShowSupportMessageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Support:',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShowSupportMessageScreen(),
              ),
            );
          },
          child: const Text('Messages..', style: TextStyle(fontSize: 20, color: Colors.white),),
        ),
      ],
    );
  }
}
