import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../providers/globe_provider.dart';
import '../../utils/helpers.dart';

class CelestialCarousel extends StatelessWidget {
  const CelestialCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final isIOS = isIOSPlatform(context);
    if (isIOS) {
      return const _CupertinoCelestialCarouselView();
    }
    return const _MaterialCelestialCarouselView();
  }
}

// ---------------------------------------------------------------------------
// iOS Cupertino Native Celestial Carousel (Apple HIG Floating Graphite Strip)
// ---------------------------------------------------------------------------
class _CupertinoCelestialCarouselView extends StatelessWidget {
  const _CupertinoCelestialCarouselView();

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobeProvider>(
      builder: (context, provider, _) {
        final bodies = provider.allBodies;
        final selectedId = provider.selectedBody.id;

        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 4, 10, 12),
            child: SizedBox(
              height: 104,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                itemCount: bodies.length,
                itemBuilder: (context, index) {
                  final body = bodies[index];
                  final isSelected = body.id == selectedId;
                  final indexStr = (index + 1).toString().padLeft(2, '0');

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        provider.selectCelestialBody(body);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 240),
                        curve: Curves.easeOutCubic,
                        width: isSelected ? 116 : 94,
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.cardElevated
                              : AppColors.cardDark.withOpacity(0.92),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? body.themeColor
                                : const Color(0x1FFFFFFF),
                            width: isSelected ? 1.8 : 0.8,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: body.themeColor.withOpacity(0.35),
                                    blurRadius: 14,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                              : null,
                        ),
                        child: Stack(
                          children: [
                            // Order index in top-right corner
                            Positioned(
                              top: 2,
                              right: 4,
                              child: Text(
                                indexStr,
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? body.themeColor.withOpacity(0.8)
                                      : const Color(0xFF52525B),
                                ),
                              ),
                            ),
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Planet Spherical Thumbnail with Cosmic Glow
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 240),
                                    width: isSelected ? 42 : 35,
                                    height: isSelected ? 42 : 35,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? body.themeColor
                                            : Colors.transparent,
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: isSelected
                                              ? body.themeColor.withOpacity(0.55)
                                              : Colors.black.withOpacity(0.5),
                                          blurRadius: isSelected ? 8 : 4,
                                        ),
                                      ],
                                    ),
                                    child: ClipOval(
                                      child: Image.asset(
                                        body.texturePath,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),

                                  // High Contrast Planet Name
                                  Text(
                                    body.name,
                                    style: TextStyle(
                                      fontSize: isSelected ? 12.5 : 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: CupertinoColors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                  // Planet Type Tag
                                  Text(
                                    body.type.split(' ').first,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? body.themeColor
                                          : AppColors.textSecondary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Android Material 3 Native Celestial Carousel (Floating M3 Strip)
// ---------------------------------------------------------------------------
class _MaterialCelestialCarouselView extends StatelessWidget {
  const _MaterialCelestialCarouselView();

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobeProvider>(
      builder: (context, provider, _) {
        final bodies = provider.allBodies;
        final selectedId = provider.selectedBody.id;

        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 4, 10, 12),
            child: SizedBox(
              height: 104,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                itemCount: bodies.length,
                itemBuilder: (context, index) {
                  final body = bodies[index];
                  final isSelected = body.id == selectedId;
                  final indexStr = (index + 1).toString().padLeft(2, '0');

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          HapticFeedback.lightImpact();
                          provider.selectCelestialBody(body);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 240),
                          curve: Curves.easeOutCubic,
                          width: isSelected ? 116 : 94,
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.cardElevated
                                : AppColors.cardDark.withOpacity(0.92),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? body.themeColor
                                  : AppColors.glassBorder,
                              width: isSelected ? 1.8 : 0.8,
                            ),
                            boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: body.themeColor.withOpacity(0.35),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                              : null,
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 2,
                                right: 4,
                                child: Text(
                                  indexStr,
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? body.themeColor.withOpacity(0.8)
                                        : const Color(0xFF52525B),
                                  ),
                                ),
                              ),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 240),
                                      width: isSelected ? 42 : 35,
                                      height: isSelected ? 42 : 35,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected
                                              ? body.themeColor
                                              : Colors.transparent,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: ClipOval(
                                        child: Image.asset(
                                          body.texturePath,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      body.name,
                                      style: TextStyle(
                                        fontSize: isSelected ? 12.5 : 11.5,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      body.type.split(' ').first,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? body.themeColor
                                            : AppColors.textSecondary,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
