import 'package:flutter/material.dart';

enum TimeControlPreset {
  ultraBullet(0, 15, 0, 'UltraBullet', Icons.rocket_launch_rounded),
  bullet(1, 0, 0, 'Bullet', Icons.crisis_alert_rounded),
  blitz(3, 0, 0, 'Blitz', Icons.bolt_rounded),
  blitzInc(3, 0, 2, 'Blitz', Icons.bolt_rounded),
  rapid(10, 0, 0, 'Rapid', Icons.cruelty_free_rounded),
  rapidInc(10, 0, 5, 'Rapid', Icons.cruelty_free_rounded),
  classical(
    15,
    0,
    10,
    'Classical',
    Icons.shield_rounded,
  ), // Turtle Shell analog
  custom(3, 0, 2, 'Custom', Icons.tune_rounded);

  final int minutes;
  final int extraSeconds;
  final int increment;
  final String category;
  final IconData icon;

  const TimeControlPreset(
    this.minutes,
    this.extraSeconds,
    this.increment,
    this.category,
    this.icon,
  );

  String get label {
    if (this == TimeControlPreset.custom) return 'Customized';
    if (this == TimeControlPreset.ultraBullet) return '15s + $increment';
    return '$minutes + $increment';
  }
}
