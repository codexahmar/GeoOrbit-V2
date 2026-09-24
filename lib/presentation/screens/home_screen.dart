import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../providers/globe_provider.dart';
import '../../utils/helpers.dart';
import '../widgets/animated_globe_container.dart';
import '../widgets/control_panel.dart';
import '../widgets/texture_selector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
          height: MediaQuery.of(context).size.height * 0.82,
          decoration: const BoxDecoration(
            color: CupertinoColors.systemGroupedBackground,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: CupertinoPageScaffold(
            backgroundColor: CupertinoColors.systemGroupedBackground,
            navigationBar: CupertinoNavigationBar(
              backgroundColor: const Color(0xE61C1C1E),
              middle: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(child: child),
          ],
        ),
      ),
    );
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
  // iOS Cupertino Screen (Apple Maps & Fitness Pro Feel)
  // -------------------------------------------------------------------------
  Widget _buildCupertinoHomeScreen(bool isMobile) {
    return Consumer<GlobeProvider>(
      builder: (context, provider, _) {
        final body = provider.selectedBody;

        return CupertinoPageScaffold(
          backgroundColor: CupertinoColors.black,
          navigationBar: CupertinoNavigationBar(
            backgroundColor: const Color(0xCC000000),
            middle: Text(
              body?.name ?? 'Cosmic Globe',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),
            leading: isMobile
                ? CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => _showCupertinoSheet(
                      title: 'Controls & Waypoints',
                      child: const ControlPanel(),
                    ),
                    child: const Icon(
                      CupertinoIcons.slider_horizontal_3,
                      color: CupertinoColors.activeBlue,
                    ),
                  )
                : null,
            trailing: isMobile
                ? CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => _showCupertinoSheet(
                      title: 'Solar System',
                      child: const TextureSelector(),
                    ),
                    child: const Icon(
                      CupertinoIcons.circle_grid_hex,
                      color: CupertinoColors.activeBlue,
                    ),
                  )
                : null,
          ),
          child: SafeArea(
            child: isMobile
                ? Stack(
                    children: [
                      const Center(
                        child: AnimatedGlobeContainer(),
                      ),
                      // Floating Apple Cupertino Quick Dock
                      Positioned(
                        bottom: 16,
                        left: 24,
                        right: 24,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xE61C1C1E),
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () => _showCupertinoSheet(
                                  title: 'Controls & Waypoints',
                                  child: const ControlPanel(),
                                ),
                                child: const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(CupertinoIcons.slider_horizontal_3,
                                        color: CupertinoColors.activeBlue, size: 22),
                                    SizedBox(height: 2),
                                    Text('Controls',
                                        style: TextStyle(
                                            fontSize: 10, color: CupertinoColors.secondaryLabel)),
                                  ],
                                ),
                              ),
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  HapticFeedback.selectionClick();
                                  provider.toggleRotation();
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      provider.isRotating
                                          ? CupertinoIcons.pause_circle_fill
                                          : CupertinoIcons.play_circle_fill,
                                      color: provider.isRotating
                                          ? CupertinoColors.systemGreen
                                          : CupertinoColors.systemGrey,
                                      size: 24,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      provider.isRotating ? 'Spinning' : 'Paused',
                                      style: const TextStyle(
                                          fontSize: 10, color: CupertinoColors.secondaryLabel),
                                    ),
                                  ],
                                ),
                              ),
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  HapticFeedback.selectionClick();
                                  provider.resetRotation();
                                },
                                child: const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(CupertinoIcons.arrow_counterclockwise,
                                        color: CupertinoColors.systemOrange, size: 22),
                                    SizedBox(height: 2),
                                    Text('Reset',
                                        style: TextStyle(
                                            fontSize: 10, color: CupertinoColors.secondaryLabel)),
                                  ],
                                ),
                              ),
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () => _showCupertinoSheet(
                                  title: 'Solar System',
                                  child: const TextureSelector(),
                                ),
                                child: const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(CupertinoIcons.globe,
                                        color: CupertinoColors.systemPurple, size: 22),
                                    SizedBox(height: 2),
                                    Text('Planets',
                                        style: TextStyle(
                                            fontSize: 10, color: CupertinoColors.secondaryLabel)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : const Row(
                    children: [
                      SizedBox(width: 320, child: ControlPanel()),
                      Expanded(
                        child: Center(child: AnimatedGlobeContainer()),
                      ),
                      SizedBox(width: 320, child: TextureSelector()),
                    ],
                  ),
          ),
        );
      },
    );
  }

  // -------------------------------------------------------------------------
  // Android Material 3 Screen
  // -------------------------------------------------------------------------
  Widget _buildMaterialHomeScreen(bool isMobile) {
    return Consumer<GlobeProvider>(
      builder: (context, provider, _) {
        final body = provider.selectedBody;

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppColors.voidBlack,
          drawer: isMobile ? _buildMaterialDrawer(isLeft: true) : null,
          endDrawer: isMobile ? _buildMaterialDrawer(isLeft: false) : null,
          appBar: AppBar(
            backgroundColor: AppColors.primaryDark,
            elevation: 0,
            title: Text(
              body?.name ?? 'Cosmic Globe',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            leading: isMobile
                ? IconButton(
                    icon: const Icon(Icons.tune),
                    color: AppColors.neonCyan,
                    onPressed: () => _showMaterialBottomSheet(
                      title: 'Controls & Waypoints',
                      child: const ControlPanel(),
                    ),
                  )
                : null,
            actions: isMobile
                ? [
                    IconButton(
                      icon: const Icon(Icons.public),
                      color: AppColors.neonPurple,
                      onPressed: () => _showMaterialBottomSheet(
                        title: 'Solar System',
                        child: const TextureSelector(),
                      ),
                    ),
                  ]
                : null,
          ),
          body: Row(
            children: [
              if (!isMobile) const SizedBox(width: 320, child: ControlPanel()),
              const Expanded(
                child: Center(child: AnimatedGlobeContainer()),
              ),
              if (!isMobile) const SizedBox(width: 320, child: TextureSelector()),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMaterialDrawer({required bool isLeft}) {
    return Drawer(
      backgroundColor: AppColors.primaryDark,
      child: isLeft ? const ControlPanel() : const TextureSelector(),
    );
  }
}
