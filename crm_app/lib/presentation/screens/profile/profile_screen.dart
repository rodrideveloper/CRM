import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../providers/auth_provider.dart';
import '../../providers/client_provider.dart';
import '../../providers/locale_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/user_profile_provider.dart';
import '../../widgets/paywall_bottom_sheet.dart';
import '../../widgets/pipeline_settings_sheet.dart';
import '../../../core/services/export_service.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.profileTitle.toUpperCase(),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton.filledTonal(
              tooltip: context.l10n.logout,
              onPressed: () => _confirmLogout(context, ref),
              style: IconButton.styleFrom(
                backgroundColor: DesignTokens.error.withValues(alpha: 0.14),
                foregroundColor: DesignTokens.error,
              ),
              icon: const Icon(Icons.logout_rounded),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Avatar with green ring
            Center(
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: DesignTokens.primaryGradient,
                ),
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: DesignTokens.surface,
                  ),
                  child: CircleAvatar(
                    radius: 44,
                    backgroundColor: DesignTokens.surfaceContainerHigh,
                    child: Text(
                      user?.email?.substring(0, 1).toUpperCase() ??
                          '?', // ignore: invalid_null_aware_operator
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: DesignTokens.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user?.email ?? context.l10n.noEmail,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'ID: ${user?.id ?? '-'}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: DesignTokens.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // Plan card
            const _PlanCard(),
            const SizedBox(height: 16),
            // Menu cards
            _MenuCard(
              icon: Icons.bar_chart_rounded,
              label: context.l10n.metricsTitle,
              color: DesignTokens.primary,
              onTap: () => context.push('/metrics'),
            ),
            const SizedBox(height: 8),
            _MenuCard(
              icon: Icons.view_column_rounded,
              label: 'Configurar pipeline',
              color: DesignTokens.secondaryFixed,
              onTap: () => showPipelineSettingsSheet(context),
            ),
            const SizedBox(height: 8),
            _MenuCard(
              icon: Icons.notifications_outlined,
              label: 'Notificaciones',
              color: DesignTokens.warning,
              onTap: () {},
            ),
            const SizedBox(height: 8),
            _MenuCard(
              icon: Icons.settings_outlined,
              label: context.l10n.settings,
              color: DesignTokens.info,
              onTap: () {
                _showSettingsSheet(context, ref);
              },
            ),
            const SizedBox(height: 8),
            _MenuCard(
              icon: Icons.file_download_outlined,
              label: context.l10n.exportCsv,
              color: DesignTokens.secondaryFixed,
              onTap: () => _exportClients(context, ref),
            ),
            const SizedBox(height: 24),
            // Lead capture form card
            _LeadFormCard(),
            const SizedBox(height: 48),
            // Logout button
            OutlinedButton.icon(
              onPressed: () => _confirmLogout(context, ref),
              icon: const Icon(Icons.logout_rounded),
              label: Text(context.l10n.logout),
              style: OutlinedButton.styleFrom(
                foregroundColor: DesignTokens.error,
                side: BorderSide(
                  color: DesignTokens.error.withValues(alpha: 0.2),
                ),
                minimumSize: const Size.fromHeight(50),
              ),
            ),
            const SizedBox(height: 24),
            // Version
            Center(
              child: Text(
                'v2.4.0-AR',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: DesignTokens.onSurfaceVariant,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportClients(BuildContext context, WidgetRef ref) async {
    final clients = ref.read(clientsProvider).valueOrNull;
    if (clients == null || clients.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.noClients)));
      return;
    }
    try {
      await ExportService().exportClientsCsv(clients);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.somethingWentWrong)),
        );
      }
    }
  }

  void _showSettingsSheet(BuildContext context, WidgetRef ref) {
    final themeMode = ref.read(themeModeProvider);

    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'CONFIGURACIÓN',
              style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              context.l10n.theme.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: DesignTokens.onSurfaceVariant,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<ThemeMode>(
                segments: [
                  ButtonSegment(
                    value: ThemeMode.light,
                    icon: const Icon(Icons.light_mode_rounded, size: 18),
                    label: Text(context.l10n.themeLight),
                  ),
                  ButtonSegment(
                    value: ThemeMode.system,
                    icon: const Icon(Icons.brightness_auto_rounded, size: 18),
                    label: Text(context.l10n.themeAuto),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    icon: const Icon(Icons.dark_mode_rounded, size: 18),
                    label: Text(context.l10n.themeDark),
                  ),
                ],
                selected: {themeMode},
                onSelectionChanged: (modes) {
                  ref.read(themeModeProvider.notifier).state = modes.first;
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              context.l10n.language.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: DesignTokens.onSurfaceVariant,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<Locale?>(
                segments: const [
                  ButtonSegment(value: Locale('es'), label: Text('ES')),
                  ButtonSegment(value: Locale('en'), label: Text('EN')),
                  ButtonSegment(value: Locale('pt'), label: Text('PT')),
                ],
                selected: {ref.read(localeProvider) ?? const Locale('es')},
                onSelectionChanged: (locales) {
                  ref.read(localeProvider.notifier).state = locales.first;
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.logout),
        content: Text(context.l10n.logoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(context.l10n.logout),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await ref.read(authNotifierProvider.notifier).signOut();
    }
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: DesignTokens.surfaceContainer,
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          border: Border.all(
            color: DesignTokens.outlineVariant.withValues(alpha: 0.12),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(DesignTokens.radiusS),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: DesignTokens.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _LeadFormCard extends ConsumerWidget {
  static const _formBaseUrl = 'trat.ar/f/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final profileAsync = ref.watch(userProfileProvider);
    final limitsAsync = ref.watch(userLimitsProvider);
    final isPro = limitsAsync.valueOrNull?.isUnlimited ?? false;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DesignTokens.surfaceContainer,
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        border: Border.all(
          color: isPro
              ? DesignTokens.primary.withValues(alpha: 0.2)
              : DesignTokens.outlineVariant.withValues(alpha: 0.12),
        ),
      ),
      child: profileAsync.when(
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        error: (_, __) => Text(
          context.l10n.somethingWentWrong,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: DesignTokens.error,
          ),
        ),
        data: (profile) {
          final formUrl = '$_formBaseUrl${profile.formToken}';

          // Free users: show locked preview
          if (!isPro) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.assignment_rounded,
                      color: DesignTokens.onSurfaceVariant,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        context.l10n.myLeadForm,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: DesignTokens.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: DesignTokens.warning.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(
                          DesignTokens.radiusFull,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.lock_rounded,
                            size: 12,
                            color: DesignTokens.warning,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'PRO',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: DesignTokens.warning,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  context.l10n.leadFormProDescription,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: DesignTokens.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => showPaywallBottomSheet(
                      context,
                      limits: limitsAsync.valueOrNull,
                    ),
                    icon: const Icon(Icons.rocket_launch_rounded, size: 16),
                    label: Text(context.l10n.upgrade),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: DesignTokens.warning,
                      side: BorderSide(
                        color: DesignTokens.warning.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          // Pro users: full form card
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.assignment_rounded,
                    color: DesignTokens.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    context.l10n.myLeadForm,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: DesignTokens.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                ),
                child: Text(
                  formUrl,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: DesignTokens.primary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: formUrl));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(context.l10n.linkCopied)),
                        );
                      },
                      icon: const Icon(Icons.copy_rounded, size: 16),
                      label: Text(context.l10n.copyLink),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Share.share('${context.l10n.shareFormText}\n$formUrl');
                      },
                      icon: const Icon(Icons.share_rounded, size: 16),
                      label: Text(context.l10n.share),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: DesignTokens.primary,
                        side: BorderSide(
                          color: DesignTokens.primary.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    profile.formEnabled
                        ? Icons.check_circle_rounded
                        : Icons.cancel_rounded,
                    size: 16,
                    color: profile.formEnabled
                        ? DesignTokens.primary
                        : DesignTokens.error,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    profile.formEnabled
                        ? context.l10n.formActive
                        : context.l10n.formInactive,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: profile.formEnabled
                          ? DesignTokens.primary
                          : DesignTokens.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PlanCard extends ConsumerWidget {
  const _PlanCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final limitsAsync = ref.watch(userLimitsProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DesignTokens.surfaceContainer,
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        border: Border.all(
          color: DesignTokens.outlineVariant.withValues(alpha: 0.12),
        ),
      ),
      child: limitsAsync.when(
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        error: (_, __) => const SizedBox.shrink(),
        data: (limits) {
          final isPro = limits.isUnlimited;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color:
                          (isPro ? DesignTokens.primary : DesignTokens.warning)
                              .withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                    ),
                    child: Icon(
                      isPro
                          ? Icons.workspace_premium_rounded
                          : Icons.diamond_outlined,
                      color: isPro
                          ? DesignTokens.primary
                          : DesignTokens.warning,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.myPlan,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isPro ? context.l10n.proPlan : context.l10n.freePlan,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isPro
                                ? DesignTokens.primary
                                : DesignTokens.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isPro)
                    TextButton(
                      onPressed: () =>
                          showPaywallBottomSheet(context, limits: limits),
                      child: Text(context.l10n.upgrade),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              // Usage bar
              if (!isPro) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.l10n.clientsUsed(
                        limits.clientCount,
                        limits.clientLimit,
                      ),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${((limits.clientCount / limits.clientLimit) * 100).toStringAsFixed(0)}%',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: DesignTokens.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: limits.clientLimit > 0
                        ? limits.clientCount / limits.clientLimit
                        : 0,
                    backgroundColor: DesignTokens.primary.withValues(
                      alpha: 0.1,
                    ),
                    valueColor: AlwaysStoppedAnimation(
                      limits.canCreateClient
                          ? DesignTokens.primary
                          : DesignTokens.error,
                    ),
                    minHeight: 8,
                  ),
                ),
              ] else
                Text(
                  context.l10n.clientsUnlimited(limits.clientCount),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: DesignTokens.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
