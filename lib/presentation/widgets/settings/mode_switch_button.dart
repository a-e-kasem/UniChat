import 'package:UniChat/logic/cubits/mode_cubit/mode_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ModeSwitchButton extends StatelessWidget {
  const ModeSwitchButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ModeCubit>().isDark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Mode:',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: () => context.read<ModeCubit>().toggleMode(),
          child: Container(
            height: 50,
            width: 100,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(50),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              alignment: isDark ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Icon(
                  isDark ? Icons.light_mode : Icons.dark_mode,
                  size: 24,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}