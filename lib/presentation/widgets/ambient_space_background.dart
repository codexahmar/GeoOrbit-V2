import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../providers/globe_provider.dart';

class AmbientSpaceBackground extends StatefulWidget {
  final Widget child;

  const AmbientSpaceBackground({super.key, required this.child});

  @override
  State<AmbientSpaceBackground> createState() => _AmbientSpaceBackgroundState();
}

class _AmbientSpaceBackgroundState extends State<AmbientSpaceBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  final List<_StarParticle> _stars = [];

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    final random = math.Random(42);
    for (int i = 0; i < 55; i++) {
      _stars.add(_StarParticle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 2.0 + 0.8,
        alpha: random.nextDouble() * 0.7 + 0.3,
        twinkleSpeed: random.nextDouble() * 0.8 + 0.4,
      ));
    }
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobeProvider>(
      builder: (context, provider, _) {
        final body = provider.selectedBody;
        final auraColor = body.glowColor ?? body.themeColor;

        return Stack(
          fit: StackFit.expand,
          children: [
            // Pure OLED Space Canvas (Deep cinematic black for perfect recording contrast)
            const DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.voidBlack,
              ),
            ),

            // Volumetric Planetary Atmosphere Nebula (Radiates against pure black)
            AnimatedBuilder(
              animation: _shimmerController,
              builder: (context, _) {
                final pulse = 0.88 + (0.12 * _shimmerController.value);

                return Stack(
                  children: [
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: const Alignment(0.0, -0.05),
                            radius: 0.80 * pulse,
                            colors: [
                              auraColor.withOpacity(0.18),
                              auraColor.withOpacity(0.04),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.48, 1.0],
                          ),
                        ),
                      ),
                    ),
                    // Ambient Twinkling Stars
                    CustomPaint(
                      painter: _StarFieldPainter(
                        stars: _stars,
                        animationValue: _shimmerController.value,
                      ),
                      size: Size.infinite,
                    ),
                  ],
                );
              },
            ),

            // Foreground Content (Globe & HUD)
            widget.child,
          ],
        );
      },
    );
  }
}

class _StarParticle {
  final double x;
  final double y;
  final double size;
  final double alpha;
  final double twinkleSpeed;

  _StarParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.alpha,
    required this.twinkleSpeed,
  });
}

class _StarFieldPainter extends CustomPainter {
  final List<_StarParticle> stars;
  final double animationValue;

  _StarFieldPainter({required this.stars, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (final star in stars) {
      final twinkle = (math.sin(animationValue * math.pi * 2 * star.twinkleSpeed) + 1) / 2;
      final currentAlpha = (star.alpha * (0.4 + 0.6 * twinkle)).clamp(0.0, 1.0);

      paint.color = Colors.white.withOpacity(currentAlpha * 0.85);
      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StarFieldPainter oldDelegate) => true;
}
