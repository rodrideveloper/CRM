import 'package:flutter/material.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../domain/entities/client.dart';
import '../../widgets/pipeline/client_card.dart';

class PipelineColumn extends StatelessWidget {
  final ClientStatus status;
  final List<Client> clients;
  final void Function(Client client) onChangeStatus;

  const PipelineColumn({
    super.key,
    required this.status,
    required this.clients,
    required this.onChangeStatus,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Column header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Text(
                status.label,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: DesignTokens.statusColor(status.value),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${clients.length}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Client list
        Expanded(
          child: clients.isEmpty
              ? Center(
                  child: Text(
                    'Sin clientes',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: clients.length,
                  itemBuilder: (context, index) {
                    final client = clients[index];
                    return ClientCard(
                      client: client,
                      onStatusChange: () => onChangeStatus(client),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
