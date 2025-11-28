class AuthTokensEntity {
  final String accessToken;
  final String refreshToken;
  final int? expiresIn;

  AuthTokensEntity({
    required this.accessToken,
    required this.refreshToken,
    this.expiresIn,
  });
}
