import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_earth_globe/flutter_earth_globe.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../providers/globe_provider.dart';
import '../../utils/helpers.dart';

class AnimatedGlobeContainer extends StatefulWidget {
  const AnimatedGlobeContainer({super.key});

  @override
  State<AnimatedGlobeContainer> createState() => _AnimatedGlobeContainerState();
}

class _AnimatedGlobeContainerState extends State<AnimatedGlobeContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _transitionController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  String _currentBodyId = '';

  @override
  void initState() {
    super.initState();

    _transitionController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(
        parent: _transitionController,
        curve: Curves.easeOutCubic,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _transitionController,
        curve: Curves.easeIn,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _transitionController.forward();
    });
  }

  @override
  void dispose() {
    _transitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isIOS = isIOSPlatform(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final radius = _calculateRadius(constraints.biggest);

        return Consumer<GlobeProvider>(
          builder: (context, provider, child) {
            if (!provider.isInitialized) {
              return Center(
                child: isIOS
                    ? const CupertinoActivityIndicator(radius: 16)
                    : const CircularProgressIndicator(color: AppColors.neonCyan),
              );
            }

            // Animate transition when switching planets
            if (_currentBodyId != provider.selectedBody.id) {
              _currentBodyId = provider.selectedBody.id;
              _transitionController.forward(from: 0.2);
            }

            final auraColor = provider.selectedBody.glowColor ??
                provider.selectedBody.themeColor;

            return Stack(
              alignment: Alignment.center,
              children: [
                // Layer 1: Outer Atmospheric Nebula Haze
                AnimatedBuilder(
                  animation: _transitionController,
                  builder: (context, child) {
                    return Container(
                      width: radius * 3.2,
                      height: radius * 3.2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            auraColor.withOpacity(0.16 * _fadeAnimation.value),
                            auraColor.withOpacity(0.04 * _fadeAnimation.value),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.45, 1.0],
                        ),
                      ),
                    );
                  },
                ),

                // Layer 2: Inner High-Intensity Planetary Corona
                AnimatedBuilder(
                  animation: _transitionController,
                  builder: (context, child) {
                    return Container(
                      width: radius * 2.2,
                      height: radius * 2.2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            auraColor.withOpacity(0.26 * _fadeAnimation.value),
                            auraColor.withOpacity(0.08 * _fadeAnimation.value),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.55, 1.0],
                        ),
                      ),
                    );
                  },
                ),

                // Layer 3: 3D High Definition Globe Sphere (Perfect proportional radius)
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: FlutterEarthGlobe(
                      controller: provider.controller,
                      radius: radius,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  double _calculateRadius(Size size) {
    final minDim = min(size.width, size.height);
    if (minDim < AppConstants.mobileBreakpoint) {
      // Proportional radius leaving clean breathing room
      return (minDim * 0.27).clamp(96.0, 138.0);
    } else if (minDim < AppConstants.tabletBreakpoint) {
      return (minDim * 0.25).clamp(130.0, 190.0);
    } else {
      return (minDim * 0.24).clamp(160.0, 240.0);
    }
  }
}
