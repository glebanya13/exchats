class UserEntity {
  final String id;
  final String username;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final bool online;
  final List<String> chats;

  UserEntity({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.online,
    required this.chats,
  });
}

