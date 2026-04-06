import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/design_tokens.dart';
import '../../core/utils/l10n_extension.dart';
import '../../domain/entities/user_profile.dart';

const _mercadoPagoUrl = 'https://www.mercadopago.com.ar';

void showPaywallBottomSheet(BuildContext context, {UserLimits? limits}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    builder: (ctx) => _PaywallSheet(limits: limits),
  );
}

class _PaywallSheet extends StatelessWidget {
  final UserLimits? limits;
  const _PaywallSheet({this.limits});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: DesignTokens.warning.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  color: DesignTokens.warning,
                  size: 36,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.upgradeToPro,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            if (limits != null && !limits!.isUnlimited)
              Text(
                context.l10n.clientLimitReached(
                  limits!.clientCount,
                  limits!.clientLimit,
                ),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: DesignTokens.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 24),

            // Plan comparison
            Row(
              children: [
                // Free plan
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: DesignTokens.surfaceContainer,
                      borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                      border: Border.all(
                        color: DesignTokens.outlineVariant.withValues(
                          alpha: 0.12,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Free',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$0',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _FeatureRow(text: context.l10n.upToNClients(15)),
                        _FeatureRow(text: context.l10n.basicPipeline),
                        _FeatureRow(text: context.l10n.notesAndTasks),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Pro plan
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          DesignTokens.primary.withValues(alpha: 0.08),
                          DesignTokens.primary.withValues(alpha: 0.15),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                      border: Border.all(
                        color: DesignTokens.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: DesignTokens.primary.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(
                              DesignTokens.radiusFull,
                            ),
                          ),
                          child: Text(
                            'PRO',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: DesignTokens.primary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$3.999',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: DesignTokens.primary,
                          ),
                        ),
                        Text(
                          '/mes',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: DesignTokens.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _FeatureRow(
                          text: context.l10n.unlimitedClients,
                          isPro: true,
                        ),
                        _FeatureRow(
                          text: context.l10n.basicPipeline,
                          isPro: true,
                        ),
                        _FeatureRow(
                          text: context.l10n.notesAndTasks,
                          isPro: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // CTA button
            Container(
              decoration: BoxDecoration(
                gradient: DesignTokens.primaryGradient,
                borderRadius: BorderRadius.circular(DesignTokens.radiusM),
              ),
              child: ElevatedButton.icon(
                onPressed: () async {
                  final uri = Uri.parse(_mercadoPagoUrl);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                icon: const Icon(Icons.rocket_launch_rounded),
                label: Text(context.l10n.subscribePro),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  minimumSize: const Size.fromHeight(52),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.cancelAnytime,
              style: theme.textTheme.bodySmall?.copyWith(
                color: DesignTokens.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String text;
  final bool isPro;
  const _FeatureRow({required this.text, this.isPro = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(
            Icons.check_rounded,
            size: 16,
            color: isPro ? DesignTokens.primary : DesignTokens.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: isPro
                    ? DesignTokens.primary
                    : DesignTokens.onSurfaceVariant,
                fontWeight: isPro ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
