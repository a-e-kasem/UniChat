import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:UniChat/logic/swich_pages_cubit/swich_pages_cubit.dart';
import 'package:UniChat/presentation/screens/account/account_screen.dart';
import 'package:UniChat/presentation/screens/home/home_screen.dart';
import 'package:UniChat/presentation/screens/settings/settings_screen.dart';
import 'package:UniChat/presentation/widgets/navigation/nav_bar_circle.dart';

// ignore: must_be_immutable
class BuildPages extends StatelessWidget {
  BuildPages({super.key});

  static const String id = 'BuildPages';

  final PageController _pageController = PageController();
  final List<Widget> pages = [AccountScreen(), HomeScreen(), SettingsScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SwichPagesCubit, SwichPagesState>(
        listener: (context, state) {
          if (state is SwichPagesHome) {
            // Lab Lab laaa
          } else if (state is SwichPagesProfile) {
            // Lab Lab laaa
          } else if (state is SwichPagesSetting) {
            // Lab Lab laaa
          }
        },
        builder: (context, state) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_pageController.hasClients) {
              _pageController.jumpToPage(
                BlocProvider.of<SwichPagesCubit>(context).selectedIndex,
              );
            }
          });

          return PageView(
            controller: _pageController,
            onPageChanged: (index) {
              BlocProvider.of<SwichPagesCubit>(context).selected(index);
            },
            children: pages,
          );
        },
      ),
      bottomNavigationBar: NavBarCircle(
        onTap: (index) {
          BlocProvider.of<SwichPagesCubit>(context).selected(index);
        },
      ),
    );
  }
}
