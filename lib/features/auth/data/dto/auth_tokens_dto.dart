class AuthTokensDto {
  final String accessToken;
  final String refreshToken;
  final int? expiresIn;

  AuthTokensDto({
    required this.accessToken,
    required this.refreshToken,
    this.expiresIn,
  });

  factory AuthTokensDto.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw const FormatException('Empty auth response');
    }
    final normalized = _unwrap(json);
    final access =
        (normalized['access_token'] ?? normalized['token']) as String? ?? '';
    final refresh = (normalized['refresh_token'] ?? normalized['refreshToken'])
            as String? ??
        '';
    final expires = normalized['expires_in'] as int?;
    if (access.isEmpty) {
      throw const FormatException('Access token not found in response');
    }
    return AuthTokensDto(
      accessToken: access,
      refreshToken: refresh.isNotEmpty
          ? refresh
          : (normalized['refresh'] as String? ?? ''),
      expiresIn: expires,
    );
  }

  static Map<String, dynamic> _unwrap(Map<String, dynamic> source) {
    final data = source['data'];
    if (data is Map<String, dynamic>) {
      return data;
    }
    return source;
  }
}
