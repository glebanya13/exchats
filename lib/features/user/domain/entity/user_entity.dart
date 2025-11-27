class UserEntity {
  final String id;
  final String name;
  final String username;
  final String phone;
  final String email;
  final String avatarUrl;
  final DateTime? insertedAt;
  final DateTime? lastSeenAt;
  final List<String> chats;

  UserEntity({
    required this.id,
    required this.name,
    required this.username,
    required this.phone,
    this.email = '',
    this.avatarUrl = '',
    this.insertedAt,
    this.lastSeenAt,
    required this.chats,
  });

  UserEntity copyWith({
    String? name,
    String? username,
    String? phone,
    String? email,
    String? avatarUrl,
    DateTime? insertedAt,
    DateTime? lastSeenAt,
    List<String>? chats,
  }) {
    return UserEntity(
      id: id,
      name: name ?? this.name,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      insertedAt: insertedAt ?? this.insertedAt,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      chats: chats ?? this.chats,
    );
  }
}
