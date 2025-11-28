import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_tokens_dto.freezed.dart';
part 'auth_tokens_dto.g.dart';

@Freezed(copyWith: false, equal: false, toJson: false)
abstract class AuthTokensDto with _$AuthTokensDto {
  const factory AuthTokensDto({
    @Default('') String accessToken,
    @Default('') String refreshToken,
    int? expiresIn,
  }) = _AuthTokensDto;

  factory AuthTokensDto.fromJson(Map<String, dynamic> json) =>
      _$AuthTokensDtoFromJson(json);
}
