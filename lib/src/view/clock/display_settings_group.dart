import 'package:flutter/material.dart';
import 'package:medieval_chess_clock/src/theme.dart';
import 'package:medieval_chess_clock/src/widgets/common_elements.dart';

class DisplaySettingsGroup extends StatelessWidget {
  final bool showOpponentTime;
  final ValueChanged<bool> onShowOpponentTimeChanged;
  final int lowTimeWarningSeconds;
  final ValueChanged<int> onLowTimeWarningChanged;

  const DisplaySettingsGroup({
    super.key,
    required this.showOpponentTime,
    required this.onShowOpponentTimeChanged,
    required this.lowTimeWarningSeconds,
    required this.onLowTimeWarningChanged,
  });

  String _formatLabel(int seconds) {
    if (seconds < 60) return '${seconds}s';
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return s == 0 ? '${m}m' : '${m}m ${s}s';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MedievalTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          _SettingsListTile(
            icon: Icons.visibility_outlined,
            iconColor: MedievalTheme.tertiary,
            iconBgColor: MedievalTheme.secondary.withValues(alpha: 0.3),
            title: 'Show Opponent Time',
            subtitle: "See opponent's remaining time",
            trailing: AppSwitch(
              value: showOpponentTime,
              onChanged: onShowOpponentTimeChanged,
            ),
          ),
          const SizedBox(height: 12),
          _SettingsListTile(
            icon: Icons.alarm,
            iconColor: Colors.red.shade700,
            iconBgColor: Colors.red.shade100,
            title: 'Low Time Warning',
            subtitle: 'Vermilion alert under crisis',
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: MedievalTheme.tertiary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _formatLabel(lowTimeWarningSeconds),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: MedievalTheme.tertiary,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: MedievalTheme.primary,
                inactiveTrackColor: MedievalTheme.secondary.withValues(
                  alpha: 0.3,
                ),
                thumbColor: MedievalTheme.primary,
                overlayColor: MedievalTheme.primary.withValues(alpha: 0.1),
                trackHeight: 6,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
              ),
              child: Slider(
                value: lowTimeWarningSeconds.toDouble(),
                min: 10,
                max: 120,
                divisions: 11, // (120 - 10) / 10 = 11 intervals
                onChanged: (val) => onLowTimeWarningChanged(val.toInt()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsListTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final Widget trailing;

  const _SettingsListTile({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: MedievalTheme.tertiary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: MedievalTheme.tertiary.withValues(alpha: 0.65),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          trailing,
        ],
      ),
    );
  }
}
