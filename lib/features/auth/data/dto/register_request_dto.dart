import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_request_dto.freezed.dart';
part 'register_request_dto.g.dart';

@Freezed(copyWith: false, equal: false, fromJson: false, toJson: true)
abstract class RegisterRequestDto with _$RegisterRequestDto {
  const factory RegisterRequestDto({required String phone}) =
      _RegisterRequestDto;
}
