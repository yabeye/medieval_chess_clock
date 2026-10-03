import 'package:flutter/material.dart';
import 'package:medieval_chess_clock/src/theme.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: MedievalTheme.neutral,
      elevation: 0,
      scrolledUnderElevation: 0,
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Row(
        children: [
          Text(
            'TIME CONTROLS',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: MedievalTheme.tertiary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            const Icon(
              Icons.settings_rounded,
              color: MedievalTheme.tertiary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Settings',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: MedievalTheme.tertiary,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class AppSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const AppSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeThumbColor: MedievalTheme.surfaceLight,
      activeTrackColor: MedievalTheme.primary,
      inactiveThumbColor: MedievalTheme.neutral,
      inactiveTrackColor: MedievalTheme.secondary.withValues(alpha: 0.5),
      thumbIcon: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const Icon(Icons.check, color: MedievalTheme.primary);
        }
        return null;
      }),
    );
  }
}
