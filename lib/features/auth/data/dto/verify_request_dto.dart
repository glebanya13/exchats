import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_request_dto.freezed.dart';
part 'verify_request_dto.g.dart';

@Freezed(copyWith: false, equal: false, fromJson: false, toJson: true)
abstract class VerifyRequestDto with _$VerifyRequestDto {
  const factory VerifyRequestDto({
    required String phone,
    required String code,
  }) = _VerifyRequestDto;
}
