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
  final ClientStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Client({
    required this.id,
    required this.userId,
    required this.name,
    this.phone,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  Client copyWith({
    String? id,
    String? userId,
    String? name,
    String? phone,
    ClientStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Client(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
