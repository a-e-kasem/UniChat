import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:UniChat/logic/cubits/swich_pages_cubit/swich_pages_cubit.dart';

// ignore: must_be_immutable
class ImageBar extends StatelessWidget {
  ImageBar({super.key});

  final userImageUrl = FirebaseAuth.instance.currentUser!.photoURL;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: BlocConsumer<SwichPagesCubit, SwichPagesState>(
        listener: (context, state) {
          if (state is SwichPagesHome) {
            // Lab Lab laaa
          } else if (state is SwichPagesProfile) {
            // Lab Lab laaa
          } else if (state is SwichPagesSetting) {
            // Lab Lab laaa
          }
        },
        builder: (context, state) => GestureDetector(
          onTap: () {
            BlocProvider.of<SwichPagesCubit>(context).selected(0);
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
