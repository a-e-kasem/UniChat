import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final url = Provider.of<ValueNotifier<String?>>(
      context,
      listen: true,
    ).value;



    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(999),
      ),
      child: (url != null && url.startsWith('http'))
          ? CircleAvatar(
              radius: 70,
              backgroundColor: Colors.black,
              backgroundImage: NetworkImage(url),
            )
          : const Icon(FontAwesomeIcons.circleUser, size: 140),
    );
  }
}
