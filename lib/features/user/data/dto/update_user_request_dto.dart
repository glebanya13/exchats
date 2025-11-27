class UpdateUserRequestDto {
  final String? avatarUrl;
  final String? name;
  final String? username;

  const UpdateUserRequestDto({
    this.avatarUrl,
    this.name,
    this.username,
  });

  Map<String, dynamic> toJson() {
    final payload = <String, dynamic>{};
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      payload['avatar_url'] = avatarUrl;
    }
    if (name != null && name!.isNotEmpty) {
      payload['name'] = name;
    }
    if (username != null && username!.isNotEmpty) {
      payload['username'] = username;
    }
    return payload;
  }

  bool get isEmpty => toJson().isEmpty;
}
