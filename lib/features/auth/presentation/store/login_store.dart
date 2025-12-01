import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:exchats/core/validators/validators.dart';
import 'package:exchats/features/auth/domain/usecase/auth_usecase.dart';
import 'package:exchats/generated/locale_keys.g.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'login_store.g.dart';

@lazySingleton
final class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store {
  final AuthUseCase _authUseCase;

  _LoginStore(this._authUseCase);

  @observable
  int selectedTab = 0;

  @observable
  Country selectedCountry = CountryParser.parseCountryCode('RU');

  @observable
  String phone = '';

  @observable
  String email = '';

  @observable
  bool isPhoneValid = false;

  @observable
  bool isEmailValid = false;

  @observable
  String? error;

  @observable
  bool isLoading = false;

  @computed
  String get phoneNumber => '+${selectedCountry.phoneCode}$phone';

  @computed
  bool get hasError => error != null;

  @computed
  bool get canSend =>
      (selectedTab == 0 ? isPhoneValid : isEmailValid) &&
      !hasError &&
      !isLoading;

  late List<ReactionDisposer> _disposers;

  void setupValidations() {
    _disposers = [
      reaction((_) => phone, validatePhone),
      reaction((_) => email, validateEmail),
    ];
  }

  @action
  void validatePhone(String phone) {
    error = null;
    if (Validate.phone(phone)) {
      isPhoneValid = true;
    } else {
      isPhoneValid = false;
      return;
    }
  }

  @action
  void validateEmail(String email) {
    error = null;
    if (email.isEmpty) {
      return;
    }
    if (Validate.email(email)) {
      isEmailValid = true;
    } else {
      error = LocaleKeys.auth_login_invalid_email.tr();
      isEmailValid = false;
      return;
    }
  }

  @action
  void setSelectedTab(int tab) {
    selectedTab = tab;
    error = null;
  }

  @action
  void setSelectedCountry(Country country) {
    selectedCountry = country;
    error = null;
  }

  @action
  Future<bool> sendVerificationCode() async {
    isLoading = true;
    error = null;
    try {
      await _authUseCase.sendVerificationCode(phoneNumber);
      return true;
    } catch (e) {
      error = LocaleKeys.auth_login_error_send_code.tr();
      return false;
    } finally {
      isLoading = false;
    }
  }

  void dispose() {
    selectedTab = 0;
    phone = '';
    email = '';
    isPhoneValid = false;
    isEmailValid = false;
    error = null;
    isLoading = false;
    for (final d in _disposers) {
      d();
    }
  }
}
