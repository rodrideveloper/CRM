import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/utils/phone_utils.dart';
import '../../../domain/entities/client.dart';

class ClientCard extends StatelessWidget {
  final Client client;
  final VoidCallback? onStatusChange;

  const ClientCard({super.key, required this.client, this.onStatusChange});

  Future<void> _openWhatsApp(BuildContext context) async {
    if (client.phone == null || client.phone!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Este cliente no tiene teléfono')),
      );
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
    final statusColor = DesignTokens.statusColor(client.status.value);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
        border: Border(left: BorderSide(color: statusColor, width: 3)),
        boxShadow: DesignTokens.shadowSoft,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          onTap: () => context.push('/client/${client.id}'),
          onLongPress: onStatusChange,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                  ),
                  child: Center(
                    child: Text(
                      client.name.isNotEmpty
                          ? client.name[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        client.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (client.company != null &&
                          client.company!.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          client.company!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: DesignTokens.accent,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (client.phone != null && client.phone!.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          client.phone!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (client.phone != null && client.phone!.isNotEmpty)
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: DesignTokens.primaryLight,
                      borderRadius: BorderRadius.circular(DesignTokens.radiusS),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.chat_rounded,
                        color: DesignTokens.primary,
                        size: 20,
                      ),
                      tooltip: 'WhatsApp',
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
