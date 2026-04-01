import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/design_tokens.dart';
import '../../core/utils/l10n_extension.dart';
import '../providers/client_provider.dart';
import '../providers/task_provider.dart';

class ShellScreen extends ConsumerWidget {
  final Widget child;
  const ShellScreen({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/tasks')) return 1;
    if (location.startsWith('/profile')) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = _currentIndex(context);
    final overdueCount = ref.watch(overdueTaskCountProvider);
    final newLeadsCount = ref.watch(newLeadsCountProvider);

    return Scaffold(
      extendBody: true,
      body: child,
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          filter: DesignTokens.glassBlur,
          child: Container(
            decoration: DesignTokens.glassDecoration,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavItem(
                      icon: Icons.view_kanban_outlined,
                      selectedIcon: Icons.view_kanban_rounded,
                      label: context.l10n.pipeline.toUpperCase(),
                      isSelected: index == 0,
                      onTap: () => context.go('/pipeline'),
                      badgeCount: newLeadsCount,
                    ),
                    _NavItem(
                      icon: Icons.checklist_rounded,
                      selectedIcon: Icons.checklist_rounded,
                      label: context.l10n.tasks.toUpperCase(),
                      isSelected: index == 1,
                      onTap: () => context.go('/tasks'),
                      badgeCount: overdueCount,
                    ),
                    _NavItem(
                      icon: Icons.person_outlined,
                      selectedIcon: Icons.person_rounded,
                      label: context.l10n.profile.toUpperCase(),
                      isSelected: index == 2,
                      onTap: () => context.go('/profile'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final int badgeCount;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? DesignTokens.surfaceContainerHigh
              : Colors.transparent,
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          border: isSelected
              ? Border.all(
                  color: DesignTokens.outlineVariant.withValues(alpha: 0.12),
                )
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Badge(
              isLabelVisible: badgeCount > 0,
              label: Text(
                '$badgeCount',
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              backgroundColor: DesignTokens.error,
              child: Icon(
                isSelected ? selectedIcon : icon,
                size: 22,
                color: isSelected
                    ? DesignTokens.primary
                    : DesignTokens.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? DesignTokens.primary
                    : DesignTokens.onSurfaceVariant,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
