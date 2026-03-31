import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../core/utils/phone_utils.dart';
import '../../../domain/entities/client.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/client/client_info_tab.dart';
import '../../widgets/client/note_list_tab.dart';
import '../../widgets/client/task_list_tab.dart';

// Provider for a single client
final clientDetailProvider = FutureProvider.family<Client, String>((ref, id) {
  return ref.read(clientRepositoryProvider).getClient(id);
});

class ClientDetailScreen extends ConsumerWidget {
  final String clientId;
  const ClientDetailScreen({super.key, required this.clientId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientAsync = ref.watch(clientDetailProvider(clientId));

    return clientAsync.when(
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: DesignTokens.primary),
        ),
      ),
      error: (err, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Error: $err')),
      ),
      data: (client) => _ClientDetailView(client: client),
    );
  }
}

class _ClientDetailView extends ConsumerWidget {
  final Client client;
  const _ClientDetailView({required this.client});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(client.name),
          actions: [
            if (client.phone != null && client.phone!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
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
                    tooltip: 'WhatsApp',
                    onPressed: () async {
                      final uri = whatsAppUri(client.phone!);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                  ),
                ),
              ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: DesignTokens.surfaceContainer,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusFull),
                  border: Border.all(
                    color: DesignTokens.outlineVariant.withValues(alpha: 0.12),
                  ),
                ),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerHeight: 0,
                  labelPadding: EdgeInsets.zero,
                  tabs: [
                    Tab(text: context.l10n.info.toUpperCase()),
                    Tab(text: context.l10n.notes.toUpperCase()),
                    Tab(text: context.l10n.tasks.toUpperCase()),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            ClientInfoTab(client: client),
            NoteListTab(clientId: client.id),
            TaskListTab(clientId: client.id),
          ],
        ),
      ),
    );
  }
}
