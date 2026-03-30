import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../domain/entities/client.dart';

extension BuildContextL10n on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

extension ClientStatusL10n on ClientStatus {
  String localizedLabel(BuildContext context) {
    final l10n = context.l10n;
    return switch (this) {
      ClientStatus.newClient => l10n.statusNew,
      ClientStatus.contacted => l10n.statusContacted,
      ClientStatus.interested => l10n.statusInterested,
      ClientStatus.negotiating => l10n.statusNegotiating,
      ClientStatus.closedWon => l10n.statusClosedWon,
      ClientStatus.closedLost => l10n.statusClosedLost,
    };
  }
}
