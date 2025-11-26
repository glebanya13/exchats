class UserDto {
  final String id;
  final String username;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final bool online;
  final List<String> chats;

  UserDto({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.online,
    required this.chats,
  });

  factory UserDto.fromJson(Map<String, dynamic> json, {String? id}) {
    return UserDto(
      id: id ?? json['id'] as String? ?? '',
      username: json['username'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      phoneNumber: json['phone_number'] as String,
      online: json['online'] as bool? ?? false,
      chats: List<String>.from(json['chats'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'online': online,
      'chats': chats,
    };
  }
}

