import 'package:flutter/material.dart';
import 'package:medieval_chess_clock/src/theme.dart';

class CustomTimeSelector extends StatelessWidget {
  final bool isActive;
  final int hours;
  final int minutes;
  final int seconds;
  final int increment;
  final Function(int h, int m, int s, int inc) onChanged;
  final VoidCallback onActivate;

  const CustomTimeSelector({
    super.key,
    required this.isActive,
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.increment,
    required this.onChanged,
    required this.onActivate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          onActivate, // Tapping anywhere in the block activates the custom preset
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isActive ? 1.0 : 0.5,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _CustomStepperCard(
                    title: 'HOURS / SIDE',
                    value: hours,
                    bottomLabel: 'Initial Bank',
                    min: 0,
                    max: 12, // Limit chess games to 12 hours
                    onChanged: (val) =>
                        onChanged(val, minutes, seconds, increment),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _CustomStepperCard(
                    title: 'MINUTES / SIDE',
                    value: minutes,
                    bottomLabel: 'Initial Bank',
                    min: 0,
                    max: 59,
                    onChanged: (val) =>
                        onChanged(hours, val, seconds, increment),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _CustomStepperCard(
                    title: 'SECONDS / SIDE',
                    value: seconds,
                    bottomLabel: 'Initial Bank',
                    min: 0,
                    max: 59,
                    onChanged: (val) =>
                        onChanged(hours, minutes, val, increment),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _CustomStepperCard(
                    title: 'INCREMENT',
                    value: increment,
                    bottomLabel: 'Fischer Delay (sec)',
                    min: 0,
                    max: 180,
                    onChanged: (val) => onChanged(hours, minutes, seconds, val),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomStepperCard extends StatelessWidget {
  final String title;
  final int value;
  final String bottomLabel;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const _CustomStepperCard({
    required this.title,
    required this.value,
    required this.bottomLabel,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MedievalTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: MedievalTheme.secondary.withValues(alpha: 0.2),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: MedievalTheme.tertiary,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StepperButton(
                icon: Icons.remove,
                onTap: () {
                  if (value > min) onChanged(value - 1);
                },
              ),
              SizedBox(
                width:
                    32, // Fixed width prevents jittering during digit changes
                child: Center(
                  child: Text(
                    value.toString(),
                    style: const TextStyle(
                      color: MedievalTheme.tertiary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ),
              _StepperButton(
                icon: Icons.add,
                onTap: () {
                  if (value < max) onChanged(value + 1);
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            bottomLabel,
            style: TextStyle(
              color: MedievalTheme.tertiary.withValues(alpha: 0.6),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _StepperButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: MedievalTheme.neutral,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: MedievalTheme.tertiary, size: 18),
      ),
    );
  }
}
