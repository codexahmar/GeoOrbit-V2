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
// iOS Cupertino Native Celestial Carousel (Apple HIG Horizontal Strip)
// ---------------------------------------------------------------------------
class _CupertinoCelestialCarouselView extends StatelessWidget {
  const _CupertinoCelestialCarouselView();

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobeProvider>(
      builder: (context, provider, _) {
        final bodies = provider.allBodies;
        final selectedId = provider.selectedBody.id;

        return SizedBox(
          height: 104,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            itemCount: bodies.length,
            itemBuilder: (context, index) {
              final body = bodies[index];
              final isSelected = body.id == selectedId;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    provider.selectCelestialBody(body);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    width: isSelected ? 116 : 94,
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF1B233D)
                          : const Color(0xCC0E1428),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isSelected
                            ? body.themeColor
                            : const Color(0x26FFFFFF),
                        width: isSelected ? 2.0 : 1.0,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: body.themeColor.withOpacity(0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Planet Spherical Thumbnail
                        Container(
                          width: isSelected ? 38 : 32,
                          height: isSelected ? 38 : 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.6),
                                blurRadius: 6,
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
                        const SizedBox(height: 4),
                        // Planet Name (High Contrast White)
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
                        // Planet Type
                        Text(
                          body.type.split(' ').first,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? body.themeColor : const Color(0xFF94A3B8),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Android Material 3 Native Celestial Carousel
// ---------------------------------------------------------------------------
class _MaterialCelestialCarouselView extends StatelessWidget {
  const _MaterialCelestialCarouselView();

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobeProvider>(
      builder: (context, provider, _) {
        final bodies = provider.allBodies;
        final selectedId = provider.selectedBody.id;

        return SizedBox(
          height: 104,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            itemCount: bodies.length,
            itemBuilder: (context, index) {
              final body = bodies[index];
              final isSelected = body.id == selectedId;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () {
                      HapticFeedback.lightImpact();
                      provider.selectCelestialBody(body);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      width: isSelected ? 116 : 94,
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.7)
                            : Theme.of(context).colorScheme.surface.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : AppColors.glassBorder,
                          width: isSelected ? 2.0 : 1.0,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.35),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: isSelected ? 19 : 16,
                            backgroundImage: AssetImage(body.texturePath),
                          ),
                          const SizedBox(height: 4),
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
                                  ? Theme.of(context).colorScheme.primary
                                  : AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
