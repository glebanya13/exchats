import '../util/phone_number_mask.dart';
import '../constants/app_strings.dart';
import '../../../features/user/domain/entity/user_entity.dart';

class UserFormatter {
  static String formatPhone(String? phone) {
    if (phone == null || phone.isEmpty) return AppStrings.unknown;
    try {
      return PhoneNumberMask.format(
        text: phone,
        mask: '+# ### ### ## ##',
      );
    } catch (_) {
      return phone;
    }
  }

  static String resolveUserName(UserEntity? user) {
    if (user == null) return AppStrings.unknown;
    if (user.name.isNotEmpty) return user.name;
    if (user.username.isNotEmpty)
      return '${AppStrings.userPrefix}${user.username}';
    if (user.phone.isNotEmpty) return formatPhone(user.phone);
    return 'Пользователь ${user.id}';
  }

  static String resolveDisplayName(UserEntity? user) {
    if (user == null) return AppStrings.unknown;
    if (user.name.isNotEmpty) return user.name;
    if (user.username.isNotEmpty)
      return '${AppStrings.userPrefix}${user.username}';
    return AppStrings.unknown;
  }
}
