import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_tokens_dto.freezed.dart';
part 'auth_tokens_dto.g.dart';

@Freezed(copyWith: false, equal: false, toJson: false)
abstract class AuthTokensDto with _$AuthTokensDto {
  const factory AuthTokensDto({required AuthTokensDataDto data}) =
      _AuthTokensDto;

  factory AuthTokensDto.fromJson(Map<String, dynamic> json) =>
      _$AuthTokensDtoFromJson(json);
}

@Freezed(copyWith: false, equal: false, toJson: false)
abstract class AuthTokensDataDto with _$AuthTokensDataDto {
  const factory AuthTokensDataDto({
    @Default('') String accessToken,
    @Default('') String refreshToken,
    int? expiresIn,
    String? tokenType,
  }) = _AuthTokensDataDto;

  factory AuthTokensDataDto.fromJson(Map<String, dynamic> json) =>
      _$AuthTokensDataDtoFromJson(json);
}
