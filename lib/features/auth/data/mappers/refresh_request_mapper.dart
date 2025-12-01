import '../../domain/entities/entities.dart';
import '../dto/dto.dart';

abstract final class RefreshRequestMapper {
  static RefreshRequestEntity toEntity({required RefreshRequestDto from}) {
    return RefreshRequestEntity(refreshToken: from.refreshToken);
  }
}
