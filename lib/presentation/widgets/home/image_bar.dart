import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_chat/data/models/selected_Index.dart';

class ImageBar extends StatelessWidget {
  ImageBar({super.key});

  final userImageUrl = FirebaseAuth.instance.currentUser!.photoURL;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Consumer<SelectedIndex>(
        builder: (context, index, child) => GestureDetector(
          onTap: () {
            index.setSelectedIndex(0);
          },
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: userImageUrl == null
                ? const Icon(Icons.person, color: Colors.black)
                : Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.greenAccent, width: 5),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        userImageUrl!,
                        width: 55,
                        height: 55,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
