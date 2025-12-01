import 'package:easy_localization/easy_localization.dart';
import 'package:exchats/core/assets/gen/assets.gen.dart';
import 'package:exchats/core/assets/gen/fonts.gen.dart';
import 'package:exchats/core/di/locator.dart';
import 'package:exchats/core/widgets/pinput/app_pinput.dart';
import 'package:exchats/features/auth/presentation/store/verification_store.dart';
import 'package:exchats/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:exchats/core/constants/app_colors.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

final class VerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const VerificationScreen({super.key, required this.phoneNumber});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

final class _VerificationScreenState extends State<VerificationScreen> {
  late VerificationStore store;

  @override
  void initState() {
    super.initState();
    store = locator<VerificationStore>();
    store.init(widget.phoneNumber);
  }

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Center(
          child: Observer(
            builder: (context) {
              return SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12.0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 20.0,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.subSurface,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: AppColors.borderSecondary),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Assets.auth.logo.image(width: 64.0, height: 64.0),
                      const SizedBox(height: 12.0),
                      Text(
                        LocaleKeys.auth_verification_title.tr(),
                        style: TextStyle(
                          fontFamily: FontFamily.inter,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.onPrimary,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              store.hasError
                                  ? store.error!
                                  : LocaleKeys.auth_verification_enter_code
                                        .tr(),
                              style: TextStyle(
                                fontFamily: FontFamily.inter,
                                fontSize: 12.0,
                                color: store.hasError
                                    ? AppColors.errorPrimary
                                    : AppColors.onSubSurface,
                              ),
                            ),
                            const SizedBox(height: 12.0),
                            AppPinput(
                              length: 6,
                              onChanged: (code) => store.code = code,
                              onCompleted: (code) => _sendCode(),
                              showError: store.hasError,
                            ),
                            const SizedBox(height: 12.0),
                            _buildLoginButton(theme),
                            Column(children: [


                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      _buildTermsLink(theme),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _sendCode() async {
    store.verifyCode().then((result) async {
      if (result && mounted) {
        context.go('/');
      }
    });
  }

  Widget _buildLoginButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: store.canSend ? () => _sendCode() : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: store.canSend
              ? theme.colorScheme.secondary
              : const Color(0xFFE0E0E0),
          foregroundColor: store.canSend ? Colors.white : Colors.grey[600],
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 0,
        ),
        child: store.isLoading
            ? const SizedBox(
                height: 20.0,
                width: 20.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  color: Colors.white,
                ),
              )
            : Text(
                LocaleKeys.auth_verification_button_title.tr(),
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
      ),
    );
  }

  Widget _buildTermsLink(ThemeData theme) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        LocaleKeys.auth_verification_terms_of_service.tr(),
        style: TextStyle(
          fontFamily: FontFamily.inter,
          fontSize: 13.0,
          color: AppColors.onSubSurface,
          fontWeight: FontWeight.w500,
          decoration: TextDecoration.underline,
          decorationStyle: TextDecorationStyle.dotted,
        ),
      ),
    );
  }
}
