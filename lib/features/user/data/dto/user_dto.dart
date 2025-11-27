class UserDto {
  final String id;
  final String name;
  final String username;
  final String phone;
  final String email;
  final String avatarUrl;
  final DateTime? insertedAt;
  final DateTime? lastSeenAt;
  final List<String> chats;

  UserDto({
    required this.id,
    required this.name,
    required this.username,
    required this.phone,
    required this.email,
    required this.avatarUrl,
    this.insertedAt,
    this.lastSeenAt,
    required this.chats,
  });

  factory UserDto.fromJson(Map<String, dynamic> json, {String? id}) {
    final rawId = id ?? json['id'];
    final normalizedId = rawId != null ? rawId.toString() : '';
    final inserted = json['inserted_at'] != null
        ? DateTime.tryParse(json['inserted_at'] as String)
        : null;
    final lastSeen = json['last_seen_at'] != null
        ? DateTime.tryParse(json['last_seen_at'] as String)
        : null;
    return UserDto(
      id: normalizedId,
      name: (json['name'] as String?) ?? '',
      username: (json['username'] as String?) ?? '',
      phone: (json['phone'] as String?) ?? '',
      email: (json['email'] as String?) ?? '',
      avatarUrl: (json['avatar_url'] as String?) ?? '',
      insertedAt: inserted,
      lastSeenAt: lastSeen,
      chats: List<String>.from(json['chats'] ?? const []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'phone': phone,
      'email': email,
      'avatar_url': avatarUrl,
      'inserted_at': insertedAt?.toIso8601String(),
      'last_seen_at': lastSeenAt?.toIso8601String(),
      'chats': chats,
    };
  }
}
