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
    final statusColor = DesignTokens.statusColor(status.value);

    return Column(
      children: [
        // Column header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(DesignTokens.radiusM),
            border: Border(left: BorderSide(color: statusColor, width: 3)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  status.label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusL),
                ),
                child: Text(
                  '${clients.length}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('📭', style: TextStyle(fontSize: 32)),
                      const SizedBox(height: 8),
                      Text(
                        'Sin clientes',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
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
