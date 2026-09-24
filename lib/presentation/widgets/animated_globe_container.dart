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
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
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
                    ? const CupertinoActivityIndicator(radius: 14)
                    : const CircularProgressIndicator(color: AppColors.neonCyan),
              );
            }

            final themeColor = provider.selectedBody?.themeColor ?? AppColors.neonCyan;

            return Stack(
              alignment: Alignment.center,
              children: [
                // Soft Atmospheric Radial Glow
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Container(
                      width: radius * 2.8,
                      height: radius * 2.8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            themeColor.withOpacity(0.12 * _fadeAnimation.value),
                            themeColor.withOpacity(0.03 * _fadeAnimation.value),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    );
                  },
                ),

                // High Definition 3D Globe Sphere
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: FlutterEarthGlobe(
                      controller: provider.controller,
                      radius: radius,
                      onTap: provider.setClickCoordinates,
                      onHover: provider.setHoverCoordinates,
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
      return (minDim * 0.35).clamp(120.0, 180.0);
    } else if (minDim < AppConstants.tabletBreakpoint) {
      return (minDim * 0.32).clamp(160.0, 240.0);
    } else {
      return (minDim * 0.32).clamp(200.0, 340.0);
    }
  }
}
