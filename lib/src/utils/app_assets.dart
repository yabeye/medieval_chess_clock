abstract class AppAssets {
  static const String logo = 'assets/images/logo.png';

  // sounds
  static const String clockTick = 'assets/sounds/clock_tick.mp3';
  static const String lowTime = 'assets/sounds/low_time.mp3';

  static List<String> get allSoundAssets => [clockTick, lowTime];
}
