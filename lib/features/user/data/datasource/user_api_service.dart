import 'package:exchats/core/api/api_provider.dart';
import 'package:exchats/features/user/data/dto/update_user_request_dto.dart';
import 'package:exchats/features/user/data/dto/user_dto.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
final class UserApiService {
  final ApiProvider _apiProvider;

  UserApiService(this._apiProvider);

  Future<UserDto> updateUser({
    required String id,
    required UpdateUserRequestDto body,
  }) async {
    final response = await _apiProvider.put<Map<String, dynamic>>(
      '/api/users/$id',
      data: body.toJson(),
    );

    final raw = response.data ?? <String, dynamic>{};
    final data = raw['data'] is Map<String, dynamic>
        ? raw['data'] as Map<String, dynamic>
        : raw;
    return UserDto.fromJson(data);
  }
}
