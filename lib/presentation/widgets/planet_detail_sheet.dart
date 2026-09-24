import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
// iOS Cupertino Native Planet Detail View (Apple HIG Clean Graphite Insets)
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
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 40),
            children: [
              // 1. Planet Hero Card (Fully visible at top with radiant aura)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardElevated,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: body.themeColor.withOpacity(0.55),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: body.themeColor.withOpacity(0.18),
                      blurRadius: 18,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Spherical Planet Preview
                    Container(
                      width: 66,
                      height: 66,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: body.themeColor.withOpacity(0.45),
                            blurRadius: 14,
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
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: body.themeColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            body.distanceFromSun,
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // 2. Study Description / Educational Overview
              _buildSectionTitle('ABOUT ${body.name.toUpperCase()}'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0x1AFFFFFF)),
                ),
                child: Text(
                  body.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFE4E4E7),
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // 3. Key Quick Facts & Measurements Bento Grid
              _buildSectionTitle('MEASUREMENTS & ORBITAL TELEMETRY'),
              const SizedBox(height: 8),
              _buildCupertinoMetricGrid(body),

              const SizedBox(height: 18),

              // 4. Atmospheric Breakdown
              if (body.atmosphere.isNotEmpty) ...[
                _buildSectionTitle('ATMOSPHERIC COMPOSITION'),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0x1AFFFFFF)),
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
                            // Native Cupertino Smooth Progress Bar (Zero Material dependencies)
                            Container(
                              height: 6,
                              decoration: BoxDecoration(
                                color: const Color(0x1AFFFFFF),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: FractionallySizedBox(
                                  widthFactor: percent,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: body.themeColor,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
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
                  color: const Color(0xFF1E1B14),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFFFB703).withOpacity(0.6),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFB703).withOpacity(0.08),
                      blurRadius: 12,
                    ),
                  ],
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
                          color: Color(0xFFF4F4F5),
                          height: 1.45,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary,
        letterSpacing: 0.9,
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
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x1AFFFFFF)),
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
                    fontSize: 11,
                    color: AppColors.textSecondary,
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
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 40),
          children: [
            // 1. Planet Header Card (Fully visible at top)
            Card.filled(
              color: AppColors.cardElevated,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
                side: BorderSide(color: body.themeColor.withOpacity(0.55), width: 1.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 33,
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
                          const SizedBox(height: 2),
                          Text(
                            body.distanceFromSun,
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: AppColors.textSecondary,
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
                    letterSpacing: 0.9,
                  ),
            ),
            const SizedBox(height: 6),
            Card.outlined(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  body.description,
                  style: const TextStyle(fontSize: 14, color: Color(0xFFE4E4E7), height: 1.5),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // 3. Key Measurements Grid
            Text(
              'MEASUREMENTS & ORBITAL TELEMETRY',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.9,
                  ),
            ),
            const SizedBox(height: 6),
            _buildM3MetricGrid(body),

            const SizedBox(height: 14),

            // 4. Atmosphere
            if (body.atmosphere.isNotEmpty) ...[
              Text(
                'ATMOSPHERIC COMPOSITION',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.9,
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
                    letterSpacing: 0.9,
                  ),
            ),
            const SizedBox(height: 6),
            Card.filled(
              color: const Color(0xFF1E1B14),
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
                        style: const TextStyle(fontSize: 13.5, color: Colors.white, height: 1.45),
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
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
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
