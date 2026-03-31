import 'package:flutter/material.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../domain/entities/client.dart';
import '../../widgets/pipeline/client_card.dart';

class PipelineColumn extends StatelessWidget {
  final ClientStatus status;
  final List<Client> clients;
  final void Function(Client client) onChangeStatus;
  final Future<void> Function()? onRefresh;

  const PipelineColumn({
    super.key,
    required this.status,
    required this.clients,
    required this.onChangeStatus,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (clients.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_rounded,
              size: 48,
              color: DesignTokens.onSurfaceVariant.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 12),
            Text(
              context.l10n.noClients,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: DesignTokens.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: DesignTokens.primary,
      onRefresh: onRefresh ?? () async {},
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 100),
        itemCount: clients.length,
        itemBuilder: (context, index) {
          final client = clients[index];
          return ClientCard(
            client: client,
            onStatusChange: () => onChangeStatus(client),
          );
        },
      ),
    );
  }
}
