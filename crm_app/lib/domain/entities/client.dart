enum ClientStatus {
  newClient('new', 'Nuevo'),
  contacted('contacted', 'Contactado'),
  interested('interested', 'Interesado'),
  negotiating('negotiating', 'Negociando'),
  closedWon('closed_won', 'Ganado'),
  closedLost('closed_lost', 'Perdido');

  const ClientStatus(this.value, this.label);
  final String value;
  final String label;

  static ClientStatus fromString(String value) {
    return ClientStatus.values.firstWhere((e) => e.value == value);
  }
}

class Client {
  final String id;
  final String userId;
  final String name;
  final String? phone;
  final String? email;
  final String? company;
  final String? source;
  final ClientStatus status;
  final double? dealValue;
  final String? currency;
  final DateTime? nextFollowUp;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Client({
    required this.id,
    required this.userId,
    required this.name,
    this.phone,
    this.email,
    this.company,
    this.source,
    required this.status,
    this.dealValue,
    this.currency,
    this.nextFollowUp,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get hasFollowUpDue =>
      nextFollowUp != null && nextFollowUp!.isBefore(DateTime.now());

  Client copyWith({
    String? id,
    String? userId,
    String? name,
    String? phone,
    String? email,
    String? company,
    String? source,
    ClientStatus? status,
    double? dealValue,
    String? currency,
    bool clearDealValue = false,
    DateTime? nextFollowUp,
    bool clearFollowUp = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Client(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      company: company ?? this.company,
      source: source ?? this.source,
      status: status ?? this.status,
      dealValue: clearDealValue ? null : (dealValue ?? this.dealValue),
      currency: currency ?? this.currency,
      nextFollowUp: clearFollowUp ? null : (nextFollowUp ?? this.nextFollowUp),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
