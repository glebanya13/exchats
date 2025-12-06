final class CallTokenDto {
  final int expiresIn;
  final String jitsiToken;
  final String jitsiUrl;
  final String roomName;

  CallTokenDto({
    required this.expiresIn,
    required this.jitsiToken,
    required this.jitsiUrl,
    required this.roomName,
  });

  factory CallTokenDto.fromJson(Map<String, dynamic> json) {
    return CallTokenDto(
      expiresIn: json['expires_in'] as int? ?? 0,
      jitsiToken: json['jitsi_token'] as String? ?? '',
      jitsiUrl: json['jitsi_url'] as String? ?? '',
      roomName: json['room_name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'expires_in': expiresIn,
      'jitsi_token': jitsiToken,
      'jitsi_url': jitsiUrl,
      'room_name': roomName,
    };
  }
}

