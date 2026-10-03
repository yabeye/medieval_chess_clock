import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class SoundService {
  // Singleton pattern for global access
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  late AudioPlayer _audioPlayer;

  // Cache to store multiple sound bytes keyed by their asset path
  final Map<String, Uint8List> _cachedAudioBytes = {};
  bool _isInitialized = false;

  /// Call this in `main()` with a list of asset paths to preload all sounds into memory
  Future<void> init(List<String> assetPaths) async {
    if (_isInitialized) return;

    _audioPlayer = AudioPlayer();
    await _audioPlayer.setReleaseMode(ReleaseMode.stop);

    try {
      for (final path in assetPaths) {
        final ByteData data = await rootBundle.load(path);
        _cachedAudioBytes[path] = data.buffer.asUint8List();
      }
      _isInitialized = true;
      log(
        'SoundService: Successfully preloaded ${_cachedAudioBytes.length} sounds.',
        name: 'SoundService',
      );
    } catch (e) {
      log('SoundService: Error preloading sounds: $e', name: 'SoundService');
      _isInitialized = false;
    }
  }

  /// Instantly play any preloaded sound from memory by passing its asset path
  Future<void> playSound(String assetPath) async {
    log('SoundService: playSound($assetPath) called', name: 'SoundService');

    if (!_isInitialized) {
      log('SoundService: Not initialized yet.', name: 'SoundService');
      return;
    }

    final bytes = _cachedAudioBytes[assetPath];
    if (bytes == null) {
      log(
        'SoundService: Sound not found in cache: $assetPath',
        name: 'SoundService',
      );
      return;
    }

    try {
      // Stop any ongoing playback to re-trigger instantly
      await _audioPlayer.stop();
      await _audioPlayer.play(BytesSource(bytes));
    } catch (e) {
      log(
        'SoundService: Playback error for $assetPath:$e',
        name: 'SoundService',
      );
    }
  }


  /// Clean up player resources if needed
  void dispose() {
    _audioPlayer.dispose();
  }
}
