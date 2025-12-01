import '../../domain/entities/entities.dart';
import '../dto/dto.dart';

abstract final class AuthTokensMapper {
  static AuthTokensEntity toEntity({required AuthTokensDto from}) {
    return AuthTokensEntity(
      accessToken: from.data.accessToken,
      refreshToken: from.data.refreshToken,
      expiresIn: from.data.expiresIn,
    );
  }
}
