abstract class Validate {
  static bool phone(String phone) {
    final regex = RegExp(r'^\d{9,14}$');
    return regex.hasMatch(phone);
  }

  static bool email(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,10}$');
    return regex.hasMatch(email);
  }

  static bool oneTimeCode(String code, {int length = 6}) {
    final regex = RegExp("^\\d{$length}\$");

    return regex.hasMatch(code);
  }
}
