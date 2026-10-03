import 'package:flutter/material.dart';
import 'package:medieval_chess_clock/src/theme.dart';
import 'package:medieval_chess_clock/src/view/clock/time_controls_screen.dart';

class ClockControlBar extends StatelessWidget {
  final bool isPaused;
  final bool hasStarted;
  final VoidCallback onPauseToggle;
  final VoidCallback onReset;

  const ClockControlBar({
    super.key,
    required this.isPaused,
    required this.hasStarted,
    required this.onPauseToggle,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            color: MedievalTheme.tertiary,
            iconSize: 26,
            onPressed: onReset,
            tooltip: 'Reset Match',
          ),
          IconButton(
            icon: Icon(
              isPaused || !hasStarted
                  ? Icons.play_arrow_rounded
                  : Icons.pause_rounded,
            ),
            color: MedievalTheme.primary,
            iconSize: 36,
            onPressed: onPauseToggle,
            tooltip: isPaused ? 'Resume' : 'Pause',
          ),
          IconButton(
            icon: const Icon(Icons.timer_outlined),
            color: MedievalTheme.tertiary,
            iconSize: 26,
            onPressed: () {
              // push as stack
              Navigator.of(context).push(
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 600),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const TimeControlsScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                ),
              );
            },
            tooltip: 'Clock Settings',
          ),
        ],
      ),
    );
  }
}
