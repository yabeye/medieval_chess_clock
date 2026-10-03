import 'package:flutter/material.dart';
import 'package:medieval_chess_clock/src/constants.dart';
import 'package:medieval_chess_clock/src/theme.dart';
import 'package:medieval_chess_clock/src/utils/app_assets.dart';
import 'package:medieval_chess_clock/src/utils/screen.dart';
import 'package:medieval_chess_clock/src/view/home/chess_clock_screen.dart';
import 'package:medieval_chess_clock/src/widgets/subtle_checker_background.dart';

class AppInitializationScreen extends StatefulWidget {
  const AppInitializationScreen({super.key});

  @override
  State<AppInitializationScreen> createState() =>
      _AppInitializationScreenState();
}

class _AppInitializationScreenState extends State<AppInitializationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const ChessClockScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double logoSize = context.isTablet ? 120 : 100;

    return Scaffold(
      body: SubtleCheckerBackground(
        opacity: 0.04,
        child: Stack(
          children: [
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.wPercent(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Minimalist Logo Container
                        Container(
                          width: logoSize,
                          height: logoSize,
                          decoration: BoxDecoration(
                            color: MedievalTheme.surfaceLight,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: MedievalTheme.secondary.withValues(
                                alpha: 0.4,
                              ),
                              width: 1.5,
                            ),

                            boxShadow: [
                              BoxShadow(
                                color: MedievalTheme.tertiary.withValues(
                                  alpha: 0.05,
                                ),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(logoSize / 2),
                              child: Image.asset(
                                AppAssets.logo,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: context.hPercent(4)),

                        // App Title
                        Text(
                          'MEDIEVAL CHESS CLOCK',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                letterSpacing: 2.5,
                                fontWeight: FontWeight.bold,
                                color: MedievalTheme.tertiary,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: context.hPercent(5)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: context.screenPadding.bottom + 24,
              left: 0,
              right: 0,
              child: Text(
                kAppVersion,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: MedievalTheme.secondary.withValues(alpha: 0.8),
                  fontSize: 10,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
