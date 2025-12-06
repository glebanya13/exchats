import 'package:exchats/core/api/api_provider.dart';
import 'package:exchats/features/chat/data/dto/call_token_dto.dart';
import 'package:exchats/features/chat/data/dto/message_dto.dart';
import 'package:exchats/features/chat/data/dto/message_list_response_dto.dart';
import 'package:exchats/features/chat/data/dto/room_dto.dart';
import 'package:exchats/features/chat/data/dto/room_list_response_dto.dart';
import 'package:exchats/features/chat/data/dto/room_participant_dto.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
final class RoomsApiService {
  final ApiProvider _apiProvider;

  RoomsApiService(this._apiProvider);

  Future<RoomListResponseDto> getRooms({
    int page = 1,
    int perPage = 20,
  }) async {
    final response = await _apiProvider.get<Map<String, dynamic>>(
      '/api/rooms',
      queryParameters: {
        'page': page,
        'per_page': perPage,
      },
    );
    final raw = response.data ?? <String, dynamic>{};
    return RoomListResponseDto.fromJson(raw);
  }

  Future<RoomDto> createRoom({
    required String type,
    int? otherUserId,
    String? name,
    List<int>? participantIds,
  }) async {
    final body = <String, dynamic>{
      'type': type,
    };
    if (type == 'private' && otherUserId != null) {
      body['other_user_id'] = otherUserId;
    } else if (type == 'group') {
      if (name != null) body['name'] = name;
      if (participantIds != null) body['participant_ids'] = participantIds;
    }

    final response = await _apiProvider.post<Map<String, dynamic>>(
      '/api/rooms',
      data: body,
    );
    final raw = response.data ?? <String, dynamic>{};
    final data = raw['data'] is Map<String, dynamic>
        ? raw['data'] as Map<String, dynamic>
        : raw;
    return RoomDto.fromJson(data);
  }

  Future<RoomDto> getRoomById(int id) async {
    final response = await _apiProvider.get<Map<String, dynamic>>(
      '/api/rooms/$id',
    );
    final raw = response.data ?? <String, dynamic>{};
    final data = raw['data'] is Map<String, dynamic>
        ? raw['data'] as Map<String, dynamic>
        : raw;
    return RoomDto.fromJson(data);
  }

  Future<RoomDto> updateRoom({
    required int id,
    String? name,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;

    final response = await _apiProvider.put<Map<String, dynamic>>(
      '/api/rooms/$id',
      data: body,
    );
    final raw = response.data ?? <String, dynamic>{};
    final data = raw['data'] is Map<String, dynamic>
        ? raw['data'] as Map<String, dynamic>
        : raw;
    return RoomDto.fromJson(data);
  }

  Future<void> deleteRoom(int id) async {
    await _apiProvider.delete<void>('/api/rooms/$id');
  }

  Future<RoomDto> joinRoom({
    required int id,
    required String inviteToken,
  }) async {
    final response = await _apiProvider.post<Map<String, dynamic>>(
      '/api/rooms/$id/join',
      data: {'invite_token': inviteToken},
    );
    final raw = response.data ?? <String, dynamic>{};
    final data = raw['data'] is Map<String, dynamic>
        ? raw['data'] as Map<String, dynamic>
        : raw;
    return RoomDto.fromJson(data);
  }

  Future<void> leaveRoom(int id) async {
    await _apiProvider.post<void>('/api/rooms/$id/leave');
  }

  Future<List<RoomParticipantDto>> getRoomParticipants(int id) async {
    final response = await _apiProvider.get<Map<String, dynamic>>(
      '/api/rooms/$id/participants',
    );
    final raw = response.data ?? <String, dynamic>{};
    final data = raw['data'] is List<dynamic>? ? raw['data'] as List<dynamic>? : [];
    return (data ?? [])
        .map((p) => RoomParticipantDto.fromJson(p as Map<String, dynamic>))
        .toList();
  }

  Future<MessageListResponseDto> getRoomMessages({
    required int roomId,
    String? cursor,
    int limit = 50,
  }) async {
    final queryParams = <String, dynamic>{
      'limit': limit,
    };
    if (cursor != null) {
      queryParams['cursor'] = cursor;
    }

    final response = await _apiProvider.get<Map<String, dynamic>>(
      '/api/rooms/$roomId/messages',
      queryParameters: queryParams,
    );
    final raw = response.data ?? <String, dynamic>{};
    return MessageListResponseDto.fromJson(raw);
  }

  Future<MessageDto> createMessage({
    required int roomId,
    required String content,
    String type = 'text',
    String? fileName,
    String? filePath,
    int? fileSize,
    String? fileType,
    Map<String, dynamic>? metadata,
    int? replyToId,
  }) async {
    final body = <String, dynamic>{
      'content': content,
      'type': type,
    };
    if (fileName != null) body['file_name'] = fileName;
    if (filePath != null) body['file_path'] = filePath;
    if (fileSize != null) body['file_size'] = fileSize;
    if (fileType != null) body['file_type'] = fileType;
    if (metadata != null) body['metadata'] = metadata;
    if (replyToId != null) body['reply_to_id'] = replyToId;

    final response = await _apiProvider.post<Map<String, dynamic>>(
      '/api/rooms/$roomId/messages',
      data: body,
    );
    final raw = response.data ?? <String, dynamic>{};
    final data = raw['data'] is Map<String, dynamic>
        ? raw['data'] as Map<String, dynamic>
        : raw;
    return MessageDto.fromJson(data);
  }

  Future<MessageDto> updateMessage({
    required int id,
    required String content,
  }) async {
    final response = await _apiProvider.put<Map<String, dynamic>>(
      '/api/messages/$id',
      data: {'content': content},
    );
    final raw = response.data ?? <String, dynamic>{};
    final data = raw['data'] is Map<String, dynamic>
        ? raw['data'] as Map<String, dynamic>
        : raw;
    return MessageDto.fromJson(data);
  }

  Future<void> deleteMessage(int id) async {
    await _apiProvider.delete<void>('/api/messages/$id');
  }

  Future<void> markMessagesAsRead(int roomId) async {
    await _apiProvider.post<void>('/api/rooms/$roomId/mark-read');
  }

  Future<CallTokenDto> getJitsiToken(int roomId) async {
    final response = await _apiProvider.post<Map<String, dynamic>>(
      '/api/rooms/$roomId/call/token',
    );
    final raw = response.data ?? <String, dynamic>{};
    return CallTokenDto.fromJson(raw);
  }
}

