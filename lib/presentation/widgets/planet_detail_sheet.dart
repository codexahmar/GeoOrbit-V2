import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/celestial_body_model.dart';
import '../providers/globe_provider.dart';
import '../../utils/helpers.dart';

class PlanetDetailSheet extends StatelessWidget {
  const PlanetDetailSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isIOS = isIOSPlatform(context);
    if (isIOS) {
      return const _CupertinoPlanetDetailView();
    }
    return const _MaterialPlanetDetailView();
  }
}

// ---------------------------------------------------------------------------
// iOS Cupertino Native Planet Detail View (Apple HIG Clean Sheet)
// ---------------------------------------------------------------------------
class _CupertinoPlanetDetailView extends StatelessWidget {
  const _CupertinoPlanetDetailView();

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobeProvider>(
      builder: (context, provider, _) {
        final body = provider.selectedBody;

        return CupertinoScrollbar(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 36),
            children: [
              // 1. Planet Header Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B233D),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: body.themeColor.withOpacity(0.6),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: body.themeColor.withOpacity(0.4),
                            blurRadius: 12,
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
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            body.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: CupertinoColors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            body.type,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: body.themeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 2. Study Description / Educational Overview
              _buildSectionTitle('ABOUT ${body.name.toUpperCase()}'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF151C32),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0x33FFFFFF)),
                ),
                child: Text(
                  body.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFE2E8F0),
                    height: 1.45,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // 3. Key Quick Facts & Measurements Grid
              _buildSectionTitle('MEASUREMENTS & ORBIT'),
              const SizedBox(height: 8),
              _buildCupertinoMetricGrid(body),

              const SizedBox(height: 18),

              // 4. Atmospheric Breakdown
              if (body.atmosphere.isNotEmpty) ...[
                _buildSectionTitle('ATMOSPHERE COMPOSITION'),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF151C32),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0x33FFFFFF)),
                  ),
                  child: Column(
                    children: body.atmosphere.entries.map((entry) {
                      final percent = _parsePercent(entry.value);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  entry.key,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: CupertinoColors.white,
                                  ),
                                ),
                                Text(
                                  entry.value,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF38BDF8),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: percent,
                                minHeight: 6,
                                backgroundColor: const Color(0x22FFFFFF),
                                color: body.themeColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 18),
              ],

              // 5. Student Fun Fact Card
              _buildSectionTitle('DID YOU KNOW?'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F2538),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFFFB703).withOpacity(0.6),
                    width: 1.2,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      CupertinoIcons.lightbulb_fill,
                      color: Color(0xFFFFB703),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        body.funFact,
                        style: const TextStyle(
                          fontSize: 13.5,
                          color: Color(0xFFF8FAFC),
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 6. Camera & Rotation Controls
              _buildSectionTitle('GLOBE CONTROLS'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF151C32),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0x33FFFFFF)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Auto-Rotate Sphere',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: CupertinoColors.white,
                          ),
                        ),
                        CupertinoSwitch(
                          value: provider.isRotating,
                          onChanged: (_) {
                            HapticFeedback.selectionClick();
                            provider.toggleRotation();
                          },
                        ),
                      ],
                    ),
                    const Divider(color: Color(0x22FFFFFF), height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Rotation Speed',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                        Text(
                          '${(provider.rotationSpeed * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: CupertinoColors.white,
                          ),
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
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: Color(0xFF94A3B8),
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildCupertinoMetricGrid(CelestialBodyModel body) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildMetricTile('Diameter', body.diameter, '🪐')),
            const SizedBox(width: 10),
            Expanded(child: _buildMetricTile('Distance to Sun', body.distanceFromSun, '☀️')),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _buildMetricTile('Orbital Period', body.orbitalPeriod, '🔄')),
            const SizedBox(width: 10),
            Expanded(child: _buildMetricTile('Orbital Speed', body.orbitalVelocity, '🚀')),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _buildMetricTile('Day Length', body.dayLength, '⏱️')),
            const SizedBox(width: 10),
            Expanded(child: _buildMetricTile('Surface Temp', body.surfaceTemp, '🌡️')),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _buildMetricTile('Gravity', body.gravity, '⚖️')),
            const SizedBox(width: 10),
            Expanded(child: _buildMetricTile('Known Moons', body.moonsCount, '🌕')),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricTile(String title, String value, String icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF151C32),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x26FFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 13)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF94A3B8),
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: CupertinoColors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  double _parsePercent(String val) {
    final clean = val.replaceAll('%', '').trim();
    final num = double.tryParse(clean) ?? 10.0;
    return (num / 100).clamp(0.02, 1.0);
  }
}

// ---------------------------------------------------------------------------
// Android Material 3 Native Planet Detail View
// ---------------------------------------------------------------------------
class _MaterialPlanetDetailView extends StatelessWidget {
  const _MaterialPlanetDetailView();

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobeProvider>(
      builder: (context, provider, _) {
        final body = provider.selectedBody;

        return ListView(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 36),
          children: [
            // 1. Planet Header
            Card.filled(
              color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: body.themeColor.withOpacity(0.5), width: 1.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage(body.texturePath),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            body.name,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            body.type,
                            style: TextStyle(
                              color: body.themeColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // 2. Overview Description
            Text(
              'OVERVIEW',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
            ),
            const SizedBox(height: 6),
            Card.outlined(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  body.description,
                  style: const TextStyle(fontSize: 14, color: Color(0xFFE2E8F0), height: 1.45),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // 3. Key Measurements Grid
            Text(
              'MEASUREMENTS & ORBIT',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
            ),
            const SizedBox(height: 6),
            _buildM3MetricGrid(body),

            const SizedBox(height: 14),

            // 4. Atmosphere
            if (body.atmosphere.isNotEmpty) ...[
              Text(
                'ATMOSPHERE',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
              ),
              const SizedBox(height: 6),
              Card.outlined(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: body.atmosphere.entries.map((entry) {
                      final percent = _parsePercent(entry.value);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13)),
                                Text(entry.value, style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold, fontSize: 13)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: percent,
                              minHeight: 6,
                              borderRadius: BorderRadius.circular(4),
                              color: body.themeColor,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 14),
            ],

            // 5. Fun Fact
            Text(
              'DID YOU KNOW?',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
            ),
            const SizedBox(height: 6),
            Card.filled(
              color: const Color(0xFF22293E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFFFFB703), width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lightbulb_rounded, color: Color(0xFFFFB703), size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        body.funFact,
                        style: const TextStyle(fontSize: 13.5, color: Colors.white, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // 6. Globe Controls
            Text(
              'GLOBE CONTROLS',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
            ),
            const SizedBox(height: 6),
            Card.outlined(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Auto-Rotate Sphere', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      value: provider.isRotating,
                      onChanged: (_) {
                        HapticFeedback.lightImpact();
                        provider.toggleRotation();
                      },
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Rotation Speed', style: TextStyle(color: AppColors.textSecondary)),
                        Text('${(provider.rotationSpeed * 100).toStringAsFixed(0)}%', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                    Slider(
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
            ),
          ],
        );
      },
    );
  }

  Widget _buildM3MetricGrid(CelestialBodyModel body) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildM3Tile('Diameter', body.diameter, '🪐')),
            const SizedBox(width: 10),
            Expanded(child: _buildM3Tile('Distance to Sun', body.distanceFromSun, '☀️')),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _buildM3Tile('Orbital Period', body.orbitalPeriod, '🔄')),
            const SizedBox(width: 10),
            Expanded(child: _buildM3Tile('Orbital Speed', body.orbitalVelocity, '🚀')),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _buildM3Tile('Day Length', body.dayLength, '⏱️')),
            const SizedBox(width: 10),
            Expanded(child: _buildM3Tile('Surface Temp', body.surfaceTemp, '🌡️')),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _buildM3Tile('Gravity', body.gravity, '⚖️')),
            const SizedBox(width: 10),
            Expanded(child: _buildM3Tile('Known Moons', body.moonsCount, '🌕')),
          ],
        ),
      ],
    );
  }

  Widget _buildM3Tile(String title, String value, String icon) {
    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(icon, style: const TextStyle(fontSize: 13)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 11.5, color: Color(0xFF94A3B8)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  double _parsePercent(String val) {
    final clean = val.replaceAll('%', '').trim();
    final num = double.tryParse(clean) ?? 10.0;
    return (num / 100).clamp(0.02, 1.0);
  }
}
