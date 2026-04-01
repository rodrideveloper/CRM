import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../core/utils/phone_utils.dart';
import '../../../domain/entities/client.dart';

/// Deterministic avatar color from a name string.
Color _avatarColor(String name) {
  const colors = [
    Color(0xFF4FF07F), // green
    Color(0xFF8FF4E3), // teal
    Color(0xFFFFB59B), // peach
    Color(0xFFFFB347), // orange
    Color(0xFF54A0FF), // blue
    Color(0xFFA78BFA), // purple
  ];
  final hash = name.codeUnits.fold<int>(0, (sum, c) => sum + c);
  return colors[hash % colors.length];
}

String _timeAgo(DateTime date) {
  final diff = DateTime.now().difference(date);
  if (diff.inMinutes < 60) return '${diff.inMinutes}M AGO';
  if (diff.inHours < 24) return '${diff.inHours}H AGO';
  if (diff.inDays == 1) return 'AYER';
  if (diff.inDays < 7) return '${diff.inDays}D AGO';
  return '${date.day}/${date.month}';
}

class ClientCard extends StatelessWidget {
  final Client client;
  final VoidCallback? onStatusChange;

  const ClientCard({super.key, required this.client, this.onStatusChange});

  Future<void> _openWhatsApp(BuildContext context) async {
    if (client.phone == null || client.phone!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.noPhoneNumber)));
      return;
    }
    final uri = whatsAppUri(client.phone!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _avatarColor(client.name);
    final initials = client.name
        .split(' ')
        .take(2)
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
        .join();
    final tagText = client.source ?? client.company;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: DesignTokens.surfaceContainer,
        borderRadius: BorderRadius.circular(DesignTokens.radiusL),
        border: Border.all(
          color: DesignTokens.outlineVariant.withValues(alpha: 0.12),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(DesignTokens.radiusL),
          onTap: () => context.push('/client/${client.id}'),
          onLongPress: onStatusChange,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Circular avatar
                CircleAvatar(
                  radius: 24,
                  backgroundColor: color.withValues(alpha: 0.15),
                  child: Text(
                    initials,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        client.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: DesignTokens.onSurface,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (client.phone != null && client.phone!.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          client.phone!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: DesignTokens.onSurfaceVariant,
                            fontSize: 13,
                          ),
                        ),
                      ],
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          if (tagText != null && tagText.isNotEmpty) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(
                                  DesignTokens.radiusFull,
                                ),
                              ),
                              child: Text(
                                tagText.toUpperCase(),
                                style: TextStyle(
                                  color: color,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          if (client.dealValue != null) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: DesignTokens.primary.withValues(
                                  alpha: 0.15,
                                ),
                                borderRadius: BorderRadius.circular(
                                  DesignTokens.radiusFull,
                                ),
                              ),
                              child: Text(
                                '\$ ${NumberFormat.compact(locale: 'es').format(client.dealValue)} ${client.currency ?? 'ARS'}',
                                style: const TextStyle(
                                  color: DesignTokens.primary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            _timeAgo(client.updatedAt),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: DesignTokens.onSurfaceVariant,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // WhatsApp button
                if (client.phone != null && client.phone!.isNotEmpty)
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: DesignTokens.primaryContainer.withValues(
                        alpha: 0.15,
                      ),
                      borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.chat_rounded,
                        color: DesignTokens.primaryContainer,
                        size: 20,
                      ),
                      tooltip: context.l10n.whatsapp,
                      onPressed: () => _openWhatsApp(context),
                      padding: EdgeInsets.zero,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
