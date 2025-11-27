class RegisterRequestDto {
  final String phone;

  const RegisterRequestDto({required this.phone});

  Map<String, dynamic> toJson() {
    return {'phone': phone};
  }
}
