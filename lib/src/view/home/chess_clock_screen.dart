import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medieval_chess_clock/src/providers/chess_clock_provider.dart';
import 'package:medieval_chess_clock/src/theme.dart';
import 'package:medieval_chess_clock/src/view/home/clock_control_bar.dart';
import 'package:medieval_chess_clock/src/view/home/play_clock_tile.dart';
import 'package:medieval_chess_clock/src/widgets/subtle_checker_background.dart';

class ChessClockScreen extends ConsumerWidget {
  const ChessClockScreen({super.key});

  void _showGameOverDialog(
    BuildContext context,
    WidgetRef ref,
    ActivePlayer winner,
  ) {
    final winnerLabel = winner == ActivePlayer.player1
        ? 'PLAYER 1'
        : 'PLAYER 2';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: MedievalTheme.surfaceLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: MedievalTheme.secondary.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        title: Text(
          "TIME'S UP!",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFFB71C1C),
            letterSpacing: 1.5,
          ),
        ),
        content: Text(
          '$winnerLabel WINS',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: MedievalTheme.tertiary,
            letterSpacing: 1.2,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: MedievalTheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(chessClockProvider.notifier).resetGame();
            },
            child: const Text(
              'NEW GAME',
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<ChessClockState>(chessClockProvider, (previous, next) {
      if (previous?.winner == null && next.winner != null) {
        _showGameOverDialog(context, ref, next.winner!);
      }
    });

    final clockState = ref.watch(chessClockProvider);
    final notifier = ref.read(chessClockProvider.notifier);

    return Scaffold(
      body: SubtleCheckerBackground(
        opacity: 0.08,
        child: SizedBox.expand(
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: RotatedBox(
                    quarterTurns: 2,
                    child: PlayerClockTile(
                      playerLabel: 'PLAYER 2',
                      timeRemaining: clockState.timePlayer2,
                      movesCount: clockState.movesPlayer2,
                      incrementSeconds: clockState.incrementSeconds,
                      isActive:
                          clockState.activePlayer == ActivePlayer.player2 &&
                          !clockState.isPaused,
                      opponentTimeRemaining: clockState.timePlayer1,
                      showOpponentTime: clockState.showOpponentTime,
                      onTouchDown: () =>
                          notifier.handleTouchDown(ActivePlayer.player2),
                    ),
                  ),
                ),

                ClockControlBar(
                  isPaused: clockState.isPaused,
                  hasStarted: clockState.activePlayer != ActivePlayer.none,
                  onPauseToggle: notifier.togglePause,
                  onReset: notifier.resetGame,
                  onSettingsPressed: () {},
                ),

                Expanded(
                  child: PlayerClockTile(
                    playerLabel: 'PLAYER 1',
                    timeRemaining: clockState.timePlayer1,
                    movesCount: clockState.movesPlayer1,
                    incrementSeconds: clockState.incrementSeconds,
                    isActive:
                        clockState.activePlayer == ActivePlayer.player1 &&
                        !clockState.isPaused,
                    opponentTimeRemaining: clockState.timePlayer2,
                    showOpponentTime: clockState.showOpponentTime,
                    onTouchDown: () =>
                        notifier.handleTouchDown(ActivePlayer.player1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
