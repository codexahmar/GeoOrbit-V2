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
import '../widgets/camera_control_dock.dart';
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

  void _showCupertinoSheet({required Widget child, required String title}) {
    HapticFeedback.mediumImpact();
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) => CupertinoPopupSurface(
        isSurfacePainted: false,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.84,
          decoration: const BoxDecoration(
            color: Color(0xFF10172D),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: CupertinoPageScaffold(
            backgroundColor: const Color(0xFF10172D),
            navigationBar: CupertinoNavigationBar(
              backgroundColor: const Color(0xE60D1326),
              border: const Border(bottom: BorderSide(color: Color(0x33FFFFFF), width: 0.5)),
              middle: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                  color: CupertinoColors.white,
                ),
              ),
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Text(
                  'Done',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: CupertinoColors.activeBlue,
                  ),
                ),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ),
            child: SafeArea(
              top: false,
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  void _showMaterialBottomSheet({required Widget child, required String title}) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: const Color(0xFF10172D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        side: BorderSide(color: AppColors.glassBorder, width: 1),
      ),
      builder: (ctx) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.82,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
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
            const Divider(color: Color(0x26FFFFFF)),
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

            // Bottom Area: Planet Strip + Quick Controls
            if (isMobile)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CelestialCarousel(),
                    const SizedBox(height: 4),
                    CameraControlDock(
                      onOpenPlanetDetails: () => _openPlanetDetails(true),
                    ),
                  ],
                ),
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
                        color: const Color(0xF010172D),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0x33FFFFFF)),
                      ),
                      child: const ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                        child: PlanetDetailSheet(),
                      ),
                    ),

                    // Center & Bottom Carousel
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CelestialCarousel(),
                              const SizedBox(height: 10),
                              CameraControlDock(
                                onOpenPlanetDetails: () => _openPlanetDetails(true),
                              ),
                            ],
                          ),
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

            // Bottom Area: Planet Strip + Quick Controls
            if (isMobile)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CelestialCarousel(),
                    const SizedBox(height: 4),
                    CameraControlDock(
                      onOpenPlanetDetails: () => _openPlanetDetails(false),
                    ),
                  ],
                ),
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
                        color: const Color(0xF010172D),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: const ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(28)),
                        child: PlanetDetailSheet(),
                      ),
                    ),

                    // Center & Bottom Carousel
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CelestialCarousel(),
                              const SizedBox(height: 10),
                              CameraControlDock(
                                onOpenPlanetDetails: () => _openPlanetDetails(false),
                              ),
                            ],
                          ),
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
