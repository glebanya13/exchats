import 'package:easy_localization/easy_localization.dart';
import 'package:exchats/core/validators/validators.dart';
import 'package:exchats/features/auth/domain/usecase/auth_usecase.dart';
import 'package:exchats/generated/locale_keys.g.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'verification_store.g.dart';

@lazySingleton
final class VerificationStore = _VerificationStore with _$VerificationStore;

abstract class _VerificationStore with Store {
  final AuthUseCase _authUseCase;

  _VerificationStore(this._authUseCase);

  @observable
  String phone = '';

  @observable
  String code = '';

  @observable
  bool isCodeValid = false;

  @observable
  String? error;

  @observable
  bool isLoading = false;

  @computed
  bool get hasError => error != null;

  @computed
  bool get canSend => isCodeValid && !hasError && !isLoading;

  late List<ReactionDisposer> _disposers;

  @action
  void init(String phone) {
    this.phone = phone;
    setupValidations();
  }

  void setupValidations() {
    _disposers = [reaction((_) => code, validateCode)];
  }

  @action
  void validateCode(String code) {
    error = null;
    if (Validate.oneTimeCode(code)) {
      isCodeValid = true;
    } else {
      isCodeValid = false;
      return;
    }
  }

  @action
  Future<bool> verifyCode() async {
    isLoading = true;
    error = null;
    try {
      await _authUseCase.verifyCode(phoneNumber: phone, code: code);
      return true;
    } catch (e) {
      error = LocaleKeys.auth_verification_invalid_code.tr();
      return false;
    } finally {
      isLoading = false;
    }
  }

  void dispose() {
    phone = '';
    code = '';
    isCodeValid = false;
    error = null;
    isLoading = false;
    for (final d in _disposers) {
      d();
    }
  }
}
