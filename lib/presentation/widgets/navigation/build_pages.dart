import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_chat/data/models/selected_Index.dart';
import 'package:uni_chat/presentation/screens/account/account_screen.dart';
import 'package:uni_chat/presentation/screens/home/home_screen.dart';
import 'package:uni_chat/presentation/screens/settings/settings_screen.dart';
import 'package:uni_chat/presentation/widgets/navigation/nav_bar_circle.dart';

class BuildPages extends StatefulWidget {
  const BuildPages({super.key});
  static const String id = 'BuildPages';

  @override
  State<BuildPages> createState() => _BuildPagesState();
}

class _BuildPagesState extends State<BuildPages> {
  late PageController _pageController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final selectedIndex = Provider.of<SelectedIndex>(
      context,
      listen: false,
    ).selectedIndex;
    _pageController = PageController(initialPage: selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final List<Widget> pages = [
    AccountScreen(),
    HomeScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Selector<SelectedIndex, int>(
        selector: (_, provider) => provider.selectedIndex,
        builder: (context, selectedIndex, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_pageController.hasClients) {
              _pageController.jumpToPage(selectedIndex);
            }
          });

          return PageView(
            controller: _pageController,
            onPageChanged: (index) {
              Provider.of<SelectedIndex>(
                context,
                listen: false,
              ).setSelectedIndex(index);
            },
            children: pages,
          );
        },
      ),
      bottomNavigationBar: NavBarCircle(
        onTap: (index) {
          Provider.of<SelectedIndex>(
            context,
            listen: false,
          ).setSelectedIndex(index);
        },
      ),
    );
  }
}
