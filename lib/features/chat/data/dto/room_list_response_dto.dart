import 'room_dto.dart';

final class PaginationMetaDto {
  final int page;
  final int perPage;
  final int totalCount;
  final int totalPages;

  PaginationMetaDto({
    required this.page,
    required this.perPage,
    required this.totalCount,
    required this.totalPages,
  });

  factory PaginationMetaDto.fromJson(Map<String, dynamic> json) {
    return PaginationMetaDto(
      page: json['page'] as int? ?? 1,
      perPage: json['per_page'] as int? ?? 20,
      totalCount: json['total_count'] as int? ?? 0,
      totalPages: json['total_pages'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'per_page': perPage,
      'total_count': totalCount,
      'total_pages': totalPages,
    };
  }
}

final class RoomListResponseDto {
  final List<RoomDto> data;
  final PaginationMetaDto meta;

  RoomListResponseDto({
    required this.data,
    required this.meta,
  });

  factory RoomListResponseDto.fromJson(Map<String, dynamic> json) {
    return RoomListResponseDto(
      data: (json['data'] as List<dynamic>?)
              ?.map((r) => RoomDto.fromJson(r as Map<String, dynamic>))
              .toList() ??
          [],
      meta: PaginationMetaDto.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((r) => r.toJson()).toList(),
      'meta': meta.toJson(),
    };
  }
}

