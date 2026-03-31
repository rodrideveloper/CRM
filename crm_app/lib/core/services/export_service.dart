import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../domain/entities/client.dart';

class ExportService {
  Future<void> exportClientsCsv(List<Client> clients) async {
    final buffer = StringBuffer();

    // CSV header
    buffer.writeln(
      'Nombre,Teléfono,Email,Empresa,Origen,Estado,Monto,Moneda,Creado,Actualizado',
    );

    // CSV rows
    for (final c in clients) {
      buffer.writeln([
        _escape(c.name),
        _escape(c.phone ?? ''),
        _escape(c.email ?? ''),
        _escape(c.company ?? ''),
        _escape(c.source ?? ''),
        _escape(c.status.label),
        c.dealValue?.toStringAsFixed(2) ?? '',
        c.currency ?? '',
        c.createdAt.toIso8601String(),
        c.updatedAt.toIso8601String(),
      ].join(','));
    }

    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/clientes_${DateTime.now().millisecondsSinceEpoch}.csv',
    );
    await file.writeAsString(buffer.toString());

    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'Clientes CRM',
    );
  }

  String _escape(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }
}
