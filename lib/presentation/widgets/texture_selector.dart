import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../data/models/celestial_body_model.dart';
import '../providers/globe_provider.dart';
import '../../utils/helpers.dart';

class TextureSelector extends StatelessWidget {
  const TextureSelector({super.key});

  @override
  Widget build(BuildContext context) {
    if (isIOSPlatform(context)) {
      return const _CupertinoTextureSelectorView();
    }
    return const _MaterialTextureSelectorView();
  }
}

// ---------------------------------------------------------------------------
// iOS Cupertino Native Texture Selector (Apple Music / Podcasts Inset List)
// ---------------------------------------------------------------------------
class _CupertinoTextureSelectorView extends StatelessWidget {
  const _CupertinoTextureSelectorView();

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobeProvider>(
      builder: (context, provider, _) {
        final allBodies = CelestialBodyModel.allBodies;
        final selectedId = provider.selectedBody?.id ?? 'earth';

        return CupertinoScrollbar(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: CupertinoListSection.insetGrouped(
                  header: const Text('SOLAR SYSTEM'),
                  children: [
                    for (final body in allBodies)
                      CupertinoListTile(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          provider.selectCelestialBody(body);
                        },
                        leadingSize: 40,
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            body.texturePath,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          body.name,
                          style: TextStyle(
                            fontWeight: body.id == selectedId
                                ? FontWeight.w700
                                : FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          body.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: body.id == selectedId
                            ? const Icon(
                                CupertinoIcons.checkmark_alt_circle_fill,
                                color: CupertinoColors.activeBlue,
                                size: 22,
                              )
                            : const Icon(
                                CupertinoIcons.chevron_forward,
                                color: CupertinoColors.tertiaryLabel,
                                size: 16,
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
}

// ---------------------------------------------------------------------------
// Android Material 3 Native Texture Selector
// ---------------------------------------------------------------------------
class _MaterialTextureSelectorView extends StatelessWidget {
  const _MaterialTextureSelectorView();

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobeProvider>(
      builder: (context, provider, _) {
        final allBodies = CelestialBodyModel.allBodies;
        final selectedId = provider.selectedBody?.id ?? 'earth';

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: allBodies.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final body = allBodies[index];
            final isSelected = body.id == selectedId;

            return Card(
              elevation: isSelected ? 2 : 0,
              color: isSelected
                  ? Theme.of(context).colorScheme.secondaryContainer
                  : Theme.of(context).colorScheme.surfaceVariant,
              child: ListTile(
                onTap: () {
                  HapticFeedback.lightImpact();
                  provider.selectCelestialBody(body);
                },
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    body.texturePath,
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  body.name,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  body.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: isSelected
                    ? Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
              ),
            );
          },
        );
      },
    );
  }
}
