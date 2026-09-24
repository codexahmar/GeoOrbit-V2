import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../providers/globe_provider.dart';
import '../../utils/helpers.dart';

class CameraControlDock extends StatelessWidget {
  final VoidCallback onOpenPlanetDetails;

  const CameraControlDock({
    super.key,
    required this.onOpenPlanetDetails,
  });

  @override
  Widget build(BuildContext context) {
    final isIOS = isIOSPlatform(context);
    if (isIOS) {
      return _CupertinoCameraControlDockView(
        onOpenPlanetDetails: onOpenPlanetDetails,
      );
    }
    return _MaterialCameraControlDockView(
      onOpenPlanetDetails: onOpenPlanetDetails,
    );
  }
}

// ---------------------------------------------------------------------------
// iOS Cupertino Native Camera Control Dock (Apple HIG Glass Dock)
// ---------------------------------------------------------------------------
class _CupertinoCameraControlDockView extends StatelessWidget {
  final VoidCallback onOpenPlanetDetails;

  const _CupertinoCameraControlDockView({
    required this.onOpenPlanetDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobeProvider>(
      builder: (context, provider, _) {
        final body = provider.selectedBody;

        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xCC0D1326),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: const Color(0x2EFFFFFF),
                      width: 1,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black45,
                        blurRadius: 16,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Reset Camera Button
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        color: const Color(0x28FFFFFF),
                        borderRadius: BorderRadius.circular(16),
                        onPressed: () {
                          HapticFeedback.selectionClick();
                          provider.resetRotation();
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(CupertinoIcons.arrow_counterclockwise, size: 15, color: CupertinoColors.white),
                            SizedBox(width: 5),
                            Text('Reset', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: CupertinoColors.white)),
                          ],
                        ),
                      ),

                      // Spin / Pause Button (Center Action)
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          HapticFeedback.selectionClick();
                          provider.toggleRotation();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: provider.isRotating
                                ? AppColors.neonCyan
                                : const Color(0x33FFFFFF),
                            boxShadow: provider.isRotating
                                ? [
                                    BoxShadow(
                                      color: AppColors.neonCyan.withOpacity(0.5),
                                      blurRadius: 12,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Icon(
                            provider.isRotating
                                ? CupertinoIcons.pause_fill
                                : CupertinoIcons.play_fill,
                            color: provider.isRotating ? CupertinoColors.black : CupertinoColors.white,
                            size: 19,
                          ),
                        ),
                      ),

                      // Study Planet Specs & Facts Button
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        color: body.themeColor,
                        borderRadius: BorderRadius.circular(16),
                        onPressed: () {
                          HapticFeedback.selectionClick();
                          onOpenPlanetDetails();
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(CupertinoIcons.book_fill, size: 15, color: CupertinoColors.black),
                            SizedBox(width: 6),
                            Text(
                              'Study Planet',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: CupertinoColors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Android Material 3 Native Camera Control Dock
// ---------------------------------------------------------------------------
class _MaterialCameraControlDockView extends StatelessWidget {
  final VoidCallback onOpenPlanetDetails;

  const _MaterialCameraControlDockView({
    required this.onOpenPlanetDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobeProvider>(
      builder: (context, provider, _) {
        final body = provider.selectedBody;

        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xF00D1326),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: AppColors.glassBorder,
                    width: 1,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Reset Button
                    FilledButton.tonalIcon(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      icon: const Icon(Icons.refresh_rounded, size: 16),
                      label: const Text('Reset', style: TextStyle(fontSize: 12.5)),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        provider.resetRotation();
                      },
                    ),

                    // Spin / Pause Button
                    FilledButton(
                      style: FilledButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(12),
                        backgroundColor: AppColors.neonCyan,
                        foregroundColor: AppColors.voidBlack,
                      ),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        provider.toggleRotation();
                      },
                      child: Icon(
                        provider.isRotating ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        size: 22,
                      ),
                    ),

                    // Study Planet Button
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        backgroundColor: body.themeColor,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      icon: const Icon(Icons.auto_stories_rounded, size: 16),
                      label: const Text(
                        'Study Planet',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        onOpenPlanetDetails();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
