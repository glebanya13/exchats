import 'package:exchats/view_models/base_viewmodel.dart';
import 'package:exchats/locator.dart';
import 'package:exchats/models/user_details.dart';
import 'package:exchats/services/auth_service.dart';
import 'package:exchats/services/user_service.dart';
import 'package:exchats/util/phone_number_mask.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel() {
    listenOnUserChanged();
  }

  final AuthService _authService = locator<AuthService>();
  final UserService _userService = locator<UserService>();

  UserDetails? _userDetails;
  String? _formattedPhoneNumber;

  UserDetails? get userDetails => _userDetails;

  set userDetails(UserDetails? userDetails) {
    _userDetails = userDetails;
    notifyListeners();
  }

  String? get formattedPhoneNumber => _formattedPhoneNumber;

  void listenOnUserChanged() {
    final currentUserId = _authService.currentUserId;
    if (currentUserId != null) {
      _userService
          .onUserChanged(id: currentUserId)
          .listen((userDetails) async {
        if (userDetails != null) {
          await formatPhoneNumber(userDetails.phoneNumber);
          this.userDetails = userDetails;
        }
      });
    }
  }

  void changeOnlineStatus(bool online) {
    _userService.setOnlineStatus(online);
  }

  Future<void> formatPhoneNumber(String phoneNumber) async {
    _formattedPhoneNumber = PhoneNumberMask.format(
        text: phoneNumber, mask: '+# ### ### ## ##');
  }
}
