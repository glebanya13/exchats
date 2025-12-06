import 'message_dto.dart';

final class CursorMetaDto {
  final bool hasMore;
  final String? nextCursor;

  CursorMetaDto({
    required this.hasMore,
    this.nextCursor,
  });

  factory CursorMetaDto.fromJson(Map<String, dynamic> json) {
    return CursorMetaDto(
      hasMore: json['has_more'] as bool? ?? false,
      nextCursor: json['next_cursor'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'has_more': hasMore,
      if (nextCursor != null) 'next_cursor': nextCursor,
    };
  }
}

final class MessageListResponseDto {
  final List<MessageDto> data;
  final CursorMetaDto meta;

  MessageListResponseDto({
    required this.data,
    required this.meta,
  });

  factory MessageListResponseDto.fromJson(Map<String, dynamic> json) {
    return MessageListResponseDto(
      data: (json['data'] as List<dynamic>?)
              ?.map((m) => MessageDto.fromJson(m as Map<String, dynamic>))
              .toList() ??
          [],
      meta: CursorMetaDto.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((m) => m.toJson()).toList(),
      'meta': meta.toJson(),
    };
  }
}

