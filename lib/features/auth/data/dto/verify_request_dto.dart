class VerifyRequestDto {
  final String phone;
  final String code;

  const VerifyRequestDto({
    required this.phone,
    required this.code,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'code': code,
    };
  }
}
