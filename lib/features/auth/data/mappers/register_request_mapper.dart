import '../../domain/entities/entities.dart';
import '../dto/dto.dart';

abstract final class RegisterRequestMapper {
  static RegisterRequestEntity toEntity({required RegisterRequestDto from}) {
    return RegisterRequestEntity(phone: from.phone);
  }
}
