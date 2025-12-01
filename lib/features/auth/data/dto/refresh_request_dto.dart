import 'package:freezed_annotation/freezed_annotation.dart';

part 'refresh_request_dto.freezed.dart';
part 'refresh_request_dto.g.dart';

@Freezed(copyWith: false, equal: false, fromJson: false, toJson: true)
abstract class RefreshRequestDto with _$RefreshRequestDto {
  const factory RefreshRequestDto({required String refreshToken}) =
      _RefreshRequestDto;
}
