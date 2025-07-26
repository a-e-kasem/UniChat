import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_chat/data/models/selected_Index.dart';

class NavBarCircle extends StatelessWidget {
  final void Function(int)? onTap;
  const NavBarCircle({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedColor =
        Theme.of(context).bottomNavigationBarTheme.selectedItemColor ??
        (isDark ? Colors.grey.shade300 : Colors.grey.shade700);

    return Consumer<SelectedIndex>(
      builder: (context, selectedIndex, child) => CircleNavBar(
        activeIndex: selectedIndex.selectedIndex,
        onTap: (index) {
          selectedIndex.setSelectedIndex(index);
          if (onTap != null) {
            onTap!(index);
          }
        },

        activeIcons: const [
          Icon(Icons.person, size: 30),
          Icon(Icons.home, size: 30),
          Icon(Icons.settings, size: 30),
        ],
        inactiveIcons: const [
          Text(
            "My",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            "Home",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            "Settings",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
        color: selectedColor,
        height: 70,
        circleWidth: 70,

        shadowColor: selectedColor,
        circleShadowColor: selectedColor,
        elevation: 1,
        gradient: LinearGradient(
          colors: isDark
              ? [Colors.grey.shade900, Colors.grey.shade900]
              : [Colors.grey.shade300, Colors.grey.shade300],
        ),
        circleGradient: LinearGradient(
          colors: isDark
              ? [Colors.grey.shade800, Colors.grey.shade700]
              : [Colors.grey.shade200, Colors.grey.shade300],
        ),
      ),
    );
  }
}
