import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/globe_provider.dart';
import '../../utils/helpers.dart';

class TelemetryHud extends StatelessWidget {
  final VoidCallback onOpenInfo;

  const TelemetryHud({super.key, required this.onOpenInfo});

  @override
  Widget build(BuildContext context) {
    final isIOS = isIOSPlatform(context);
    if (isIOS) {
      return _CupertinoTelemetryHudView(onOpenInfo: onOpenInfo);
    }
    return _MaterialTelemetryHudView(onOpenInfo: onOpenInfo);
  }
}

// ---------------------------------------------------------------------------
// iOS Cupertino Telemetry Top Bar (Apple Vision / HIG Glass Pill)
// ---------------------------------------------------------------------------
class _CupertinoTelemetryHudView extends StatelessWidget {
  final VoidCallback onOpenInfo;

  const _CupertinoTelemetryHudView({required this.onOpenInfo});

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobeProvider>(
      builder: (context, provider, _) {
        final body = provider.selectedBody;

        return SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xCC0B1020),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0x2EFFFFFF),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: body.themeColor.withOpacity(0.12),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Glowing Status Orb
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: body.themeColor,
                          boxShadow: [
                            BoxShadow(
                              color: body.themeColor.withOpacity(0.8),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Planet Name & Quick Spec
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          transitionBuilder: (child, anim) => FadeTransition(
                            opacity: anim,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.0, 0.15),
                                end: Offset.zero,
                              ).animate(anim),
                              child: child,
                            ),
                          ),
                          child: Column(
                            key: ValueKey(body.id),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                body.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: CupertinoColors.white,
                                  letterSpacing: -0.4,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                '${body.type} • ${body.diameter}',
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  color: Color(0xFF94A3B8),
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Cupertino Facts Pill Button
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                        color: const Color(0x2EFFFFFF),
                        borderRadius: BorderRadius.circular(16),
                        onPressed: () {
                          HapticFeedback.selectionClick();
                          onOpenInfo();
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              CupertinoIcons.sparkles,
                              size: 15,
                              color: body.themeColor,
                            ),
                            const SizedBox(width: 5),
                            const Text(
                              'Facts',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: CupertinoColors.white,
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
// Android Material 3 Telemetry Top Bar (M3 Expressive Pill)
// ---------------------------------------------------------------------------
class _MaterialTelemetryHudView extends StatelessWidget {
  final VoidCallback onOpenInfo;

  const _MaterialTelemetryHudView({required this.onOpenInfo});

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobeProvider>(
      builder: (context, provider, _) {
        final body = provider.selectedBody;

        return SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Material(
              color: Colors.transparent,
              elevation: 4,
              shadowColor: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(24),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xF00E1428),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0x33FFFFFF),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Planet Color Accent Dot
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: body.themeColor,
                        boxShadow: [
                          BoxShadow(
                            color: body.themeColor.withOpacity(0.7),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Active Planet Info
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: Column(
                          key: ValueKey(body.id),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              body.name,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                            ),
                            Text(
                              '${body.type} • ${body.diameter}',
                              style: const TextStyle(
                                fontSize: 11.5,
                                color: Color(0xFF94A3B8),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Material 3 Facts Button
                    FilledButton.tonalIcon(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      icon: Icon(Icons.insights_rounded, size: 16, color: body.themeColor),
                      label: const Text('Facts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        onOpenInfo();
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
