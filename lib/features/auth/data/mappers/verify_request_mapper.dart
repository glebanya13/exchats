import '../../domain/entities/entities.dart';
import '../dto/dto.dart';

abstract final class VerifyRequestMapper {
  static VerifyRequestEntity toEntity({required VerifyRequestDto from}) {
    return VerifyRequestEntity(phone: from.phone, code: from.code);
  }
}
