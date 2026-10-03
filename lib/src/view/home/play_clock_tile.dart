import 'package:flutter/material.dart';
import 'package:medieval_chess_clock/src/theme.dart';
import 'package:medieval_chess_clock/src/utils/screen.dart';

class PlayerClockTile extends StatelessWidget {
  final String playerLabel;
  final Duration timeRemaining;
  final int movesCount;
  final int incrementSeconds;
  final bool isActive;
  final Duration? opponentTimeRemaining;
  final bool showOpponentTime;
  final VoidCallback onTouchDown;

  const PlayerClockTile({
    super.key,
    required this.playerLabel,
    required this.timeRemaining,
    required this.movesCount,
    required this.incrementSeconds,
    required this.isActive,
    this.opponentTimeRemaining,
    this.showOpponentTime = false,
    required this.onTouchDown,
  });

  String _formatOpponentTime(Duration d) => d.inHours > 0
      ? '${d.inHours}:${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}'
      : d.inSeconds < 30 && d.inMilliseconds > 0
      ? '${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}.${d.inMilliseconds.remainder(1000) ~/ 100}'
      : '${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}';

  Widget _buildMainTimerText(BuildContext context, Color color) {
    final baseStyle = Theme.of(context).textTheme.displayLarge?.copyWith(
      fontSize: context.isTablet ? 84 : 58,
      fontWeight: FontWeight.bold,
      fontFeatures: const [FontFeature.tabularFigures()],
      color: color,
      height: 1.0,
    );

    final m = timeRemaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = timeRemaining.inSeconds.remainder(60).toString().padLeft(2, '0');

    if (timeRemaining.inHours > 0) {
      return Text.rich(
        TextSpan(
          text: '${timeRemaining.inHours}:$m',
          style: baseStyle,
          children: [
            TextSpan(
              text: ':$s',
              style: baseStyle?.copyWith(
                fontSize: (baseStyle.fontSize ?? 58) * 0.65,
                color: color.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      );
    }

    if (timeRemaining.inSeconds < 30 && timeRemaining.inMilliseconds > 0) {
      return Text(
        '$m:$s.${timeRemaining.inMilliseconds.remainder(1000) ~/ 100}',
        style: baseStyle,
      );
    }

    return Text('$m:$s', style: baseStyle);
  }

  @override
  Widget build(BuildContext context) {
    final bool isLowTime =
        timeRemaining.inSeconds < 30 && timeRemaining.inMilliseconds > 0;

    final Color backgroundColor = isActive
        ? (isLowTime ? const Color(0xFFB71C1C) : MedievalTheme.primary)
        : Color.alphaBlend(
            Colors.grey.shade600.withValues(alpha: 0.65),
            MedievalTheme.primary.withValues(alpha: 0.35),
          );

    final Color timerTextColor = isActive
        ? Colors.white
        : (isLowTime ? const Color(0xFFFF5252) : Colors.white);

    return Container(
      padding: const EdgeInsets.all(12),
      margin: isActive ? const EdgeInsets.only(right: 4) : null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => onTouchDown(),
        child: AnimatedScale(
          scale: isActive ? 1.01 : 0.99,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                bottom: -6,
                right: -6,
                child: Container(
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isActive ? 0.22 : 0.08,
                      ),
                      blurRadius: isActive ? 12 : 6,
                      offset: isActive
                          ? const Offset(0, 6)
                          : const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    decoration: BoxDecoration(color: backgroundColor),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 16.0,
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _buildMainTimerText(context, timerTextColor),
                                if (showOpponentTime &&
                                    opponentTimeRemaining != null) ...[
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(
                                        alpha: 0.25,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.15,
                                        ),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.hourglass_bottom_rounded,
                                          size: 11,
                                          color: Colors.white.withValues(
                                            alpha: 0.8,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          _formatOpponentTime(
                                            opponentTimeRemaining!,
                                          ),
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            fontFeatures: const [
                                              FontFeature.tabularFigures(),
                                            ],
                                            color: Colors.white.withValues(
                                              alpha: 0.9,
                                            ),
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        _PlayerInfoFooter(
                          playerLabel: playerLabel,
                          movesCount: movesCount,
                          incrementSeconds: incrementSeconds,
                          isActive: isActive,
                        ),
                      ],
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

class _PlayerInfoFooter extends StatelessWidget {
  final String playerLabel;
  final int movesCount;
  final int incrementSeconds;
  final bool isActive;

  const _PlayerInfoFooter({
    required this.playerLabel,
    required this.movesCount,
    required this.incrementSeconds,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final Color contentColor = Colors.white.withValues(
      alpha: isActive ? 0.95 : 0.85,
    );

    final String infoText = incrementSeconds > 0
        ? 'MOVES: $movesCount  •  +${incrementSeconds}s INCR'
        : 'MOVES: $movesCount';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: contentColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              playerLabel,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                fontSize: 13,
                color: contentColor,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Text(
            infoText,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              fontSize: 11,
              color: contentColor,
            ),
          ),
        ),
      ],
    );
  }
}
