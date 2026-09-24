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
// iOS Cupertino Clean Top Bar
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xCC0D1326),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: const Color(0x26FFFFFF),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Active Planet Name & Type
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              body.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: CupertinoColors.white,
                                letterSpacing: -0.3,
                              ),
                            ),
                            Text(
                              '${body.type} • ${body.diameter}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF94A3B8),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Explore / Info Button
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        color: const Color(0x33FFFFFF),
                        borderRadius: BorderRadius.circular(14),
                        onPressed: () {
                          HapticFeedback.selectionClick();
                          onOpenInfo();
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              CupertinoIcons.info_circle_fill,
                              size: 16,
                              color: CupertinoColors.white,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Facts',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
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
// Android Material 3 Clean Top Bar
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xE60D1326),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0x26FFFFFF),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            body.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${body.type} • ${body.diameter}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    FilledButton.tonalIcon(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      icon: const Icon(Icons.info_outline_rounded, size: 16),
                      label: const Text('Facts'),
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
