import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../providers/globe_provider.dart';
import '../../utils/helpers.dart';

class ControlPanel extends StatelessWidget {
  const ControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    if (isIOSPlatform(context)) {
      return const _CupertinoControlPanelView();
    }
    return const _MaterialControlPanelView();
  }
}

// ---------------------------------------------------------------------------
// iOS Cupertino Native Control Panel (Clean Apple Inset Grouped)
// ---------------------------------------------------------------------------
class _CupertinoControlPanelView extends StatelessWidget {
  const _CupertinoControlPanelView();

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobeProvider>(
      builder: (context, provider, _) {
        final body = provider.selectedBody;

        return CupertinoScrollbar(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              // 1. Current Body Section
              CupertinoListSection.insetGrouped(
                header: const Text('SELECTED CELESTIAL BODY'),
                children: [
                  CupertinoListTile(
                    leading: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: ClipOval(
                        child: Image.asset(
                          body?.texturePath ?? 'assets/2k_earth-day.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      body?.name ?? 'Earth',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(body?.category ?? 'Planet'),
                    trailing: Text(
                      body?.diameter ?? '',
                      style: const TextStyle(
                        fontSize: 13,
                        color: CupertinoColors.secondaryLabel,
                      ),
                    ),
                  ),
                ],
              ),

              // 2. Orbit Controls Section
              CupertinoListSection.insetGrouped(
                header: const Text('CONTROLS'),
                children: [
                  CupertinoListTile(
                    leading: _buildIconBadge(
                      icon: CupertinoIcons.arrow_2_circlepath,
                      color: CupertinoColors.activeBlue,
                    ),
                    title: const Text('Auto-Rotate'),
                    trailing: CupertinoSwitch(
                      value: provider.isRotating,
                      onChanged: (_) {
                        HapticFeedback.selectionClick();
                        provider.toggleRotation();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Rotation Speed', style: TextStyle(fontSize: 15)),
                            Text(
                              '${(provider.rotationSpeed * 100).toStringAsFixed(1)}x',
                              style: const TextStyle(color: CupertinoColors.secondaryLabel),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        CupertinoSlider(
                          value: provider.rotationSpeed,
                          min: AppConstants.minRotationSpeed,
                          max: AppConstants.maxRotationSpeed,
                          onChanged: provider.isRotating
                              ? (val) => provider.setRotationSpeed(val)
                              : null,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Zoom Level', style: TextStyle(fontSize: 15)),
                            Text(
                              '${(provider.zoom * 100).toInt()}%',
                              style: const TextStyle(color: CupertinoColors.secondaryLabel),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        CupertinoSlider(
                          value: provider.zoom,
                          min: AppConstants.minZoom,
                          max: AppConstants.maxZoom,
                          onChanged: (val) => provider.setZoom(val),
                        ),
                      ],
                    ),
                  ),
                  CupertinoListTile(
                    leading: _buildIconBadge(
                      icon: CupertinoIcons.arrow_counterclockwise,
                      color: CupertinoColors.systemOrange,
                    ),
                    title: const Text('Reset Camera'),
                    trailing: CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      color: CupertinoColors.systemGrey5,
                      borderRadius: BorderRadius.circular(8),
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        provider.resetRotation();
                      },
                      child: const Text(
                        'Reset',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: CupertinoColors.activeBlue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // 3. Earth Waypoints Section
              CupertinoListSection.insetGrouped(
                header: const Text('EARTH WAYPOINTS'),
                children: [
                  CupertinoListTile(
                    leading: _buildIconBadge(
                      icon: CupertinoIcons.airplane,
                      color: CupertinoColors.systemPink,
                    ),
                    title: const Text('Flight Trajectories'),
                    trailing: CupertinoSwitch(
                      value: provider.showConnections,
                      onChanged: (_) {
                        HapticFeedback.selectionClick();
                        provider.toggleConnections();
                      },
                    ),
                  ),
                  for (final location in provider.locations)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: location.color,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  location.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: location.isVisible
                                        ? CupertinoColors.label.resolveFrom(context)
                                        : CupertinoColors.tertiaryLabel.resolveFrom(context),
                                  ),
                                ),
                                Text(
                                  'Lat ${location.coordinates.latitude.toStringAsFixed(1)}°, Lon ${location.coordinates.longitude.toStringAsFixed(1)}°',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: CupertinoColors.secondaryLabel,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (location.isVisible)
                            CupertinoButton(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              onPressed: () {
                                HapticFeedback.selectionClick();
                                provider.focusOnLocation(location);
                              },
                              child: const Text('Focus', style: TextStyle(fontSize: 13)),
                            ),
                          CupertinoSwitch(
                            value: location.isVisible,
                            onChanged: (_) {
                              HapticFeedback.selectionClick();
                              provider.toggleLocation(location);
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIconBadge({required IconData icon, required Color color}) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, color: CupertinoColors.white, size: 16),
    );
  }
}

// ---------------------------------------------------------------------------
// Android Material 3 Native Control Panel
// ---------------------------------------------------------------------------
class _MaterialControlPanelView extends StatelessWidget {
  const _MaterialControlPanelView();

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobeProvider>(
      builder: (context, provider, _) {
        final body = provider.selectedBody;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Selected Body Card
            Card.filled(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(body?.texturePath ?? 'assets/2k_earth-day.jpg'),
                ),
                title: Text(body?.name ?? 'Earth', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(body?.category ?? 'Planet'),
                trailing: Text(body?.diameter ?? ''),
              ),
            ),
            const SizedBox(height: 12),

            // Controls Card
            Card.outlined(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Controls', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Auto-Rotate'),
                      value: provider.isRotating,
                      onChanged: (_) => provider.toggleRotation(),
                    ),
                    const SizedBox(height: 8),
                    Text('Speed: ${(provider.rotationSpeed * 100).toStringAsFixed(1)}x'),
                    Slider(
                      value: provider.rotationSpeed,
                      min: AppConstants.minRotationSpeed,
                      max: AppConstants.maxRotationSpeed,
                      onChanged: provider.isRotating
                          ? (val) => provider.setRotationSpeed(val)
                          : null,
                    ),
                    const SizedBox(height: 8),
                    Text('Zoom: ${(provider.zoom * 100).toInt()}%'),
                    Slider(
                      value: provider.zoom,
                      min: AppConstants.minZoom,
                      max: AppConstants.maxZoom,
                      onChanged: (val) => provider.setZoom(val),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.tonal(
                        onPressed: () => provider.resetRotation(),
                        child: const Text('Reset Camera'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Waypoints Card
            Card.outlined(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Earth Waypoints', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Flight Trajectories'),
                      value: provider.showConnections,
                      onChanged: (_) => provider.toggleConnections(),
                    ),
                    const Divider(),
                    for (final location in provider.locations)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(radius: 6, backgroundColor: location.color),
                        title: Text(location.name),
                        subtitle: Text('Lat ${location.coordinates.latitude.toStringAsFixed(1)}°, Lon ${location.coordinates.longitude.toStringAsFixed(1)}°'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (location.isVisible)
                              IconButton(
                                icon: const Icon(Icons.my_location, size: 20),
                                onPressed: () => provider.focusOnLocation(location),
                              ),
                            Switch(
                              value: location.isVisible,
                              onChanged: (_) => provider.toggleLocation(location),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
