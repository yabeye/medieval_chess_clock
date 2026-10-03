import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ActivePlayer { none, player1, player2 }

/// Immutable state model for the Chess Clock engine
class ChessClockState {
  final Duration timePlayer1;
  final Duration timePlayer2;
  final int movesPlayer1;
  final int movesPlayer2;
  final ActivePlayer activePlayer;
  final bool isPaused;
  final ActivePlayer? winner;
  final Duration initialTime;
  final int incrementSeconds;
  final bool showOpponentTime;

  const ChessClockState({
    required this.timePlayer1,
    required this.timePlayer2,
    this.movesPlayer1 = 0,
    this.movesPlayer2 = 0,
    this.activePlayer = ActivePlayer.none,
    this.isPaused = false,
    this.winner,
    this.initialTime = const Duration(seconds: 45),
    this.incrementSeconds = 2,
    this.showOpponentTime = true,
  });

  ChessClockState copyWith({
    Duration? timePlayer1,
    Duration? timePlayer2,
    int? movesPlayer1,
    int? movesPlayer2,
    ActivePlayer? activePlayer,
    bool? isPaused,
    ActivePlayer? winner,
    Duration? initialTime,
    int? incrementSeconds,
    bool? showOpponentTime,
  }) {
    return ChessClockState(
      timePlayer1: timePlayer1 ?? this.timePlayer1,
      timePlayer2: timePlayer2 ?? this.timePlayer2,
      movesPlayer1: movesPlayer1 ?? this.movesPlayer1,
      movesPlayer2: movesPlayer2 ?? this.movesPlayer2,
      activePlayer: activePlayer ?? this.activePlayer,
      isPaused: isPaused ?? this.isPaused,
      winner: winner,
      initialTime: initialTime ?? this.initialTime,
      incrementSeconds: incrementSeconds ?? this.incrementSeconds,
      showOpponentTime: showOpponentTime ?? this.showOpponentTime,
    );
  }
}

/// Riverpod Notifier managing high-precision chess timer logic
class ChessClockNotifier extends Notifier<ChessClockState> {
  Timer? _timer;

  @override
  ChessClockState build() {
    ref.onDispose(() => _timer?.cancel());
    const defaultTime = Duration(seconds: 600);
    return const ChessClockState(
      timePlayer1: defaultTime,
      timePlayer2: defaultTime,
    );
  }

  /// Handles instant 0ms touch-down switching
  void handleTouchDown(ActivePlayer player) {
    if (state.winner != null) return;
    if (state.timePlayer1 == Duration.zero ||
        state.timePlayer2 == Duration.zero) {
      return;
    }

    // Reject out-of-turn taps
    if (state.activePlayer == ActivePlayer.player1 &&
        player != ActivePlayer.player1) {
      return;
    }
    if (state.activePlayer == ActivePlayer.player2 &&
        player != ActivePlayer.player2) {
      return;
    }

    final increment = Duration(seconds: state.incrementSeconds);

    if (state.activePlayer == ActivePlayer.player1) {
      state = state.copyWith(
        timePlayer1: state.timePlayer1 + increment,
        movesPlayer1: state.movesPlayer1 + 1,
        activePlayer: ActivePlayer.player2,
        isPaused: false,
      );
    } else if (state.activePlayer == ActivePlayer.player2) {
      state = state.copyWith(
        timePlayer2: state.timePlayer2 + increment,
        movesPlayer2: state.movesPlayer2 + 1,
        activePlayer: ActivePlayer.player1,
        isPaused: false,
      );
    } else {
      // First tap starts the opponent's clock
      state = state.copyWith(
        activePlayer: player == ActivePlayer.player1
            ? ActivePlayer.player2
            : ActivePlayer.player1,
        isPaused: false,
      );
    }

    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    // 50ms tick interval for sub-second precision updates
    _timer = Timer.periodic(const Duration(milliseconds: 50), (_) => _tick());
  }

  void _tick() {
    if (state.isPaused || state.activePlayer == ActivePlayer.none) return;

    const tickDuration = Duration(milliseconds: 50);

    if (state.activePlayer == ActivePlayer.player1) {
      if (state.timePlayer1 <= tickDuration) {
        _timer?.cancel();
        state = state.copyWith(
          timePlayer1: Duration.zero,
          winner: ActivePlayer.player2,
        );
      } else {
        state = state.copyWith(timePlayer1: state.timePlayer1 - tickDuration);
      }
    } else if (state.activePlayer == ActivePlayer.player2) {
      if (state.timePlayer2 <= tickDuration) {
        _timer?.cancel();
        state = state.copyWith(
          timePlayer2: Duration.zero,
          winner: ActivePlayer.player1,
        );
      } else {
        state = state.copyWith(timePlayer2: state.timePlayer2 - tickDuration);
      }
    }
  }

  void togglePause() {
    if (state.activePlayer == ActivePlayer.none || state.winner != null) return;
    state = state.copyWith(isPaused: !state.isPaused);
  }

  void resetGame() {
    _timer?.cancel();
    state = ChessClockState(
      timePlayer1: state.initialTime,
      timePlayer2: state.initialTime,
      initialTime: state.initialTime,
      incrementSeconds: state.incrementSeconds,
    );
  }
}

final chessClockProvider =
    NotifierProvider<ChessClockNotifier, ChessClockState>(
      ChessClockNotifier.new,
    );
