import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medieval_chess_clock/src/model/enums.dart';
import 'package:medieval_chess_clock/src/providers/chess_clock_provider.dart';
import 'package:medieval_chess_clock/src/theme.dart';
import 'package:medieval_chess_clock/src/view/clock/custom_time_selector.dart';
import 'package:medieval_chess_clock/src/view/clock/display_settings_group.dart';
import 'package:medieval_chess_clock/src/widgets/common_elements.dart';
import 'package:medieval_chess_clock/src/widgets/subtle_checker_background.dart';

class TimeControlsScreen extends ConsumerStatefulWidget {
  const TimeControlsScreen({super.key});

  @override
  ConsumerState<TimeControlsScreen> createState() => _TimeControlsScreenState();
}

class _TimeControlsScreenState extends ConsumerState<TimeControlsScreen> {
  late TimeControlPreset _selectedPreset;
  late int _customHours;
  late int _customMinutes;
  late int _customSeconds;
  late int _customIncrement;
  late int _lowTimeWarningSeconds;
  late bool _showOpponentTime;

  @override
  void initState() {
    super.initState();
    final currentState = ref.read(chessClockProvider);
    _selectedPreset = currentState.selectedPreset ?? TimeControlPreset.blitzInc;
    _customHours = currentState.customHours;
    _customMinutes = currentState.customMinutes;
    _customSeconds = currentState.customSeconds;
    _customIncrement = currentState.customIncrement;
    _lowTimeWarningSeconds = currentState.lowTimeWarningSeconds;
    _showOpponentTime = currentState.showOpponentTime;
  }

  void _applySettingsAndPop() {
    if (_selectedPreset == TimeControlPreset.custom &&
        _customHours == 0 &&
        _customMinutes == 0 &&
        _customSeconds == 0) {
      _customSeconds = 1;
    }

    final duration = _selectedPreset == TimeControlPreset.custom
        ? Duration(
            hours: _customHours,
            minutes: _customMinutes,
            seconds: _customSeconds,
          )
        : Duration(
            minutes: _selectedPreset.minutes,
            seconds: _selectedPreset.extraSeconds,
          );

    final increment = _selectedPreset == TimeControlPreset.custom
        ? _customIncrement
        : _selectedPreset.increment;

    ref
        .read(chessClockProvider.notifier)
        .updateSettings(
          initialTime: duration,
          incrementSeconds: increment,
          selectedPreset: _selectedPreset,
          customHours: _customHours,
          customMinutes: _customMinutes,
          customSeconds: _customSeconds,
          customIncrement: _customIncrement,
          lowTimeWarningSeconds: _lowTimeWarningSeconds,
          showOpponentTime: _showOpponentTime,
        );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MedievalTheme.neutral,
      appBar: const CommonAppBar(),
      body: SafeArea(
        child: SubtleCheckerBackground(
          opacity: .03,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _SectionHeader(
                        title: 'Standard',
                        subtitle: 'STANDARD TEMPOS',
                      ),
                      const SizedBox(height: 16),
                      PresetTimeControlsGrid(
                        selectedPreset: _selectedPreset,
                        onTap: (preset) =>
                            setState(() => _selectedPreset = preset),
                      ),
                      const SizedBox(height: 32),

                      if (_selectedPreset == TimeControlPreset.custom) ...[
                        const _SectionHeader(
                          title: 'Custom Time',
                          subtitle: 'H, M, S & INCREMENT',
                        ),
                        const SizedBox(height: 16),
                        CustomTimeSelector(
                          isActive: _selectedPreset == TimeControlPreset.custom,
                          hours: _customHours,
                          minutes: _customMinutes,
                          seconds: _customSeconds,
                          increment: _customIncrement,
                          onChanged: (h, m, s, inc) {
                            setState(() {
                              _customHours = h;
                              _customMinutes = m;
                              _customSeconds = s;
                              _customIncrement = inc;
                              _selectedPreset = TimeControlPreset.custom;
                            });
                          },
                          onActivate: () {
                            setState(
                              () => _selectedPreset = TimeControlPreset.custom,
                            );
                          },
                        ),
                        const SizedBox(height: 32),
                      ],

                      const _SectionHeader(
                        title: 'Display',
                        subtitle: 'VISUAL & ALERTS',
                      ),
                      const SizedBox(height: 16),
                      // Replaced separate elements with the grouped card
                      DisplaySettingsGroup(
                        showOpponentTime: _showOpponentTime,
                        onShowOpponentTimeChanged: (val) =>
                            setState(() => _showOpponentTime = val),
                        lowTimeWarningSeconds: _lowTimeWarningSeconds,
                        onLowTimeWarningChanged: (val) =>
                            setState(() => _lowTimeWarningSeconds = val),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MedievalTheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: _applySettingsAndPop,
                    child: const Text(
                      'APPLY',
                      style: TextStyle(
                        color: MedievalTheme.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PresetTimeControlsGrid extends StatelessWidget {
  const PresetTimeControlsGrid({
    super.key,
    required this.selectedPreset,
    required this.onTap,
  });
  final TimeControlPreset selectedPreset;
  final void Function(TimeControlPreset) onTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: TimeControlPreset.values.length,
      itemBuilder: (context, index) {
        final preset = TimeControlPreset.values[index];
        return _PresetTile(
          preset: preset,
          isActive: selectedPreset == preset,
          onTap: () => onTap(preset),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: MedievalTheme.tertiary,
            fontWeight: FontWeight.w600,
          ),
        ),
        // Text(
        //   subtitle,
        //   style: Theme.of(context).textTheme.labelSmall?.copyWith(
        //     color: MedievalTheme.tertiary.withValues(alpha: 0.7),
        //     fontWeight: FontWeight.bold,
        //     letterSpacing: 1.2,
        //   ),
        // ),
      ],
    );
  }
}

class _PresetTile extends StatelessWidget {
  final TimeControlPreset preset;
  final bool isActive;
  final VoidCallback onTap;

  const _PresetTile({
    required this.preset,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: isActive ? MedievalTheme.primary : MedievalTheme.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: isActive
              ? null
              : Border.all(
                  color: MedievalTheme.secondary.withValues(alpha: 0.2),
                ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  preset.category,
                  style: TextStyle(
                    color: isActive
                        ? MedievalTheme.white
                        : MedievalTheme.tertiary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  preset.label,
                  style: TextStyle(
                    color: isActive
                        ? MedievalTheme.white.withValues(alpha: 0.8)
                        : MedievalTheme.tertiary.withValues(alpha: 0.8),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Icon(
                isActive ? Icons.check_circle_outline : preset.icon,
                color: isActive ? MedievalTheme.white : MedievalTheme.secondary,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
