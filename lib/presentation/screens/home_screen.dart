import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../providers/globe_provider.dart';
import '../../utils/helpers.dart';
import '../widgets/ambient_space_background.dart';
import '../widgets/animated_globe_container.dart';
import '../widgets/telemetry_hud.dart';
import '../widgets/celestial_carousel.dart';
import '../widgets/planet_detail_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GlobeProvider>(context, listen: false).initialize();
    });
  }

  // -------------------------------------------------------------------------
  // Ultra-Smooth Native Apple Cupertino Modal Sheet (Instant, Zero Lag)
  // -------------------------------------------------------------------------
  void _showCupertinoSheet({required Widget child, required String title}) {
    HapticFeedback.mediumImpact();
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) => SafeArea(
        top: false,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.86,
          decoration: const BoxDecoration(
            color: Color(0xFF141519), // Apple Modern Dark Graphite
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
              top: BorderSide(color: Color(0x2EFFFFFF), width: 0.8),
            ),
          ),
          child: Column(
            children: [
              // Apple Native Capsule Grab Handle
              const SizedBox(height: 8),
              Container(
                width: 38,
                height: 4.5,
                decoration: BoxDecoration(
                  color: const Color(0xFF52525B),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),

              // Header Row (Title + Apple "Done" Button)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 16, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: '.SF Pro Display',
                        fontWeight: FontWeight.w700,
                        fontSize: 17.5,
                        color: CupertinoColors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      minSize: 0,
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          fontFamily: '.SF Pro Text',
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: CupertinoColors.activeBlue,
                        ),
                      ),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
              ),
              Container(height: 0.5, color: const Color(0x1FFFFFFF)),

              // Sheet Body (Starts immediately so Planet thumbnail is 100% visible)
              Expanded(
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Ultra-Smooth Android Material 3 BottomSheet
  // -------------------------------------------------------------------------
  void _showMaterialBottomSheet({required Widget child, required String title}) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: const Color(0xFF141519),
      barrierColor: Colors.black.withOpacity(0.70),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        side: BorderSide(color: AppColors.glassBorder, width: 1),
      ),
      builder: (ctx) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        child: Column(
          children: [
            // M3 Drag Handle
            const SizedBox(height: 10),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textTertiary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 12, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
            ),
            const Divider(color: Color(0x1FFFFFFF), height: 1),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }

  void _openPlanetDetails(bool isIOS) {
    final bodyName = Provider.of<GlobeProvider>(context, listen: false).selectedBody.name;
    if (isIOS) {
      _showCupertinoSheet(
        title: '$bodyName Study Guide',
        child: const PlanetDetailSheet(),
      );
    } else {
      _showMaterialBottomSheet(
        title: '$bodyName Study Guide',
        child: const PlanetDetailSheet(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIOS = isIOSPlatform(context);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < AppConstants.desktopBreakpoint;

    if (isIOS) {
      return _buildCupertinoHomeScreen(isMobile);
    }
    return _buildMaterialHomeScreen(isMobile);
  }

  // -------------------------------------------------------------------------
  // iOS Cupertino Screen
  // -------------------------------------------------------------------------
  Widget _buildCupertinoHomeScreen(bool isMobile) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.voidBlack,
      child: AmbientSpaceBackground(
        child: Stack(
          children: [
            // 3D Center Interactive Planet Sphere
            const Center(
              child: AnimatedGlobeContainer(),
            ),

            // Top Header Bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: TelemetryHud(
                onOpenInfo: () => _openPlanetDetails(true),
              ),
            ),

            // Bottom Floating Celestial Carousel
            if (isMobile)
              const Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: CelestialCarousel(),
              )
            else
              // Desktop / Tablet Layout
              Positioned.fill(
                top: 80,
                child: Row(
                  children: [
                    // Left Rail: Study Sheet
                    Container(
                      width: 380,
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xF0141519),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0x2EFFFFFF)),
                      ),
                      child: const ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                        child: PlanetDetailSheet(),
                      ),
                    ),

                    // Center & Bottom Carousel
                    const Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 24),
                          child: CelestialCarousel(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Android Material 3 Screen
  // -------------------------------------------------------------------------
  Widget _buildMaterialHomeScreen(bool isMobile) {
    return Scaffold(
      backgroundColor: AppColors.voidBlack,
      body: AmbientSpaceBackground(
        child: Stack(
          children: [
            // 3D Center Interactive Planet Sphere
            const Center(
              child: AnimatedGlobeContainer(),
            ),

            // Top Header Bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: TelemetryHud(
                onOpenInfo: () => _openPlanetDetails(false),
              ),
            ),

            // Bottom Floating Celestial Carousel
            if (isMobile)
              const Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: CelestialCarousel(),
              )
            else
              // Desktop / Tablet Layout
              Positioned.fill(
                top: 80,
                child: Row(
                  children: [
                    // Left Rail: Study Sheet
                    Container(
                      width: 380,
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xF0141519),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: const ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(28)),
                        child: PlanetDetailSheet(),
                      ),
                    ),

                    // Center & Bottom Carousel
                    const Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 24),
                          child: CelestialCarousel(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
