import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
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
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
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
              IconButton(
                icon: const Icon(Icons.chat, color: Color(0xFF25D366)),
                tooltip: 'WhatsApp',
                onPressed: () async {
                  final phone = client.phone!.replaceAll(RegExp(r'[^\d+]'), '');
                  final uri = Uri.parse('https://wa.me/$phone');
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
              ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.person_outlined), text: 'Info'),
              Tab(icon: Icon(Icons.note_outlined), text: 'Notas'),
              Tab(icon: Icon(Icons.task_outlined), text: 'Tareas'),
            ],
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
