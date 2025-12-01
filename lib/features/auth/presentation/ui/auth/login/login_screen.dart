import 'package:easy_localization/easy_localization.dart';
import 'package:exchats/core/assets/gen/assets.gen.dart';
import 'package:exchats/core/assets/gen/fonts.gen.dart';
import 'package:exchats/features/auth/presentation/store/login_store.dart';
import 'package:exchats/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:country_picker/country_picker.dart';
import 'package:exchats/core/di/locator.dart';
import 'package:exchats/core/constants/app_colors.dart';

final class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

final class _LoginScreenState extends State<LoginScreen> {
  late LoginStore store;
  late TextEditingController phoneController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    store = locator<LoginStore>();
    store.setupValidations();
    phoneController = TextEditingController();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    phoneController.dispose();
    emailController.dispose();
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
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: AppColors.onPrimary,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          children: [
                            Text(
                              LocaleKeys.auth_login_title.tr(),
                              style: TextStyle(
                                fontFamily: FontFamily.inter,
                                fontSize: 24.0,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 12.0),
                            _buildTabs(),
                            const SizedBox(height: 14.0),
                            store.selectedTab == 0
                                ? _buildPhoneInput(theme)
                                : _buildEmailInput(theme),
                            if (store.hasError)
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 8.0,
                                  left: 0,
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    store.error!,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(height: 12.0),
                            _buildNextButton(theme),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      _buildSocialLogin(theme),
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

  Widget _buildTabs() {
    Widget tab(String title, int index) {
      final selected = store.selectedTab == index;
      return Expanded(
        child: GestureDetector(
          onTap: () => store.setSelectedTab(index),
          child: Container(
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppColors.onPrimary : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontFamily: FontFamily.inter,
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColors.onSurface,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: AppColors.gray2.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          tab(LocaleKeys.auth_login_phone.tr(), 0),
          const SizedBox(width: 6),
          tab(LocaleKeys.auth_login_email.tr(), 1),
        ],
      ),
    );
  }

  Widget _buildPhoneInput(ThemeData theme) {
    final dialCode = '+${store.selectedCountry.phoneCode}';
    return TextField(
      controller: phoneController,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(15),
      ],
      style: TextStyle(fontSize: 16.0, color: Colors.black),
      decoration: InputDecoration(
        hintText: '',
        prefixIcon: InkWell(
          borderRadius: BorderRadius.circular(8.0),
          onTap: _openCountryPicker,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  store.selectedCountry.flagEmoji,
                  style: const TextStyle(fontSize: 20.0),
                ),
                const SizedBox(width: 8.0),
                Text(
                  dialCode,
                  style: const TextStyle(fontSize: 16.0, color: Colors.black),
                ),
                const Icon(Icons.keyboard_arrow_down_rounded, size: 18.0),
              ],
            ),
          ),
        ),
        suffixIcon: store.isPhoneValid && !store.hasError
            ? Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Transform.scale(
                  scale: 0.65,
                  child: Assets.auth.acceptSvg.svg(),
                ),
              )
            : store.hasError
            ? Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Transform.scale(
                  scale: 0.65,
                  child: Assets.auth.errorSvg.svg(),
                ),
              )
            : null,
        filled: true,
        fillColor: const Color(0xFFF0F1F3),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: store.hasError ? Colors.red : Colors.transparent,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: store.hasError ? Colors.red : theme.colorScheme.secondary,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.red, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.red, width: 2.0),
        ),
      ),
      onChanged: (value) {
        final digits = value.trim();
        store.phone = digits;
      },
    );
  }

  void _openCountryPicker() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      favorite: const ['RU', 'UA', 'KZ', 'BY'],
      countryListTheme: CountryListThemeData(
        borderRadius: BorderRadius.circular(12),
        inputDecoration: InputDecoration(
          hintText: LocaleKeys.auth_login_search_country.tr(),
          prefixIcon: Icon(Icons.search),
        ),
      ),
      onSelect: (country) => store.setSelectedCountry(country),
    );
  }

  Widget _buildEmailInput(ThemeData theme) {
    return TextField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(fontSize: 16.0, color: Colors.black),
      decoration: InputDecoration(
        hintText: LocaleKeys.auth_login_enter_email.tr(),
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16.0),
        filled: true,
        fillColor: const Color(0xFFF0F1F3),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: store.hasError ? Colors.red : Colors.transparent,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: store.hasError ? Colors.red : theme.colorScheme.secondary,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.red, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.red, width: 2.0),
        ),
      ),
      onChanged: (value) => store.email = value,
    );
  }

  Widget _buildNextButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: (store.canSend)
            ? () {
                if (store.selectedTab == 0) {
                  store.sendVerificationCode().then((result) {
                    if (result && mounted) {
                      context.push(
                        '/auth/verification?phoneNumber=${store.phoneNumber}',
                      );
                    } else {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              LocaleKeys.auth_login_error_send_code.tr(),
                            ),
                          ),
                        );
                      }
                    }
                  });
                }
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: store.canSend
              ? AppColors.primary
              : const Color(0xFFF0F1F3),
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
                LocaleKeys.auth_login_button_title.tr(),
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
      ),
    );
  }

  Widget _buildSocialLogin(ThemeData theme) {
    return Column(
      children: [
        Text(
          LocaleKeys.auth_login_or_login_with.tr(),
          style: TextStyle(
            fontFamily: FontFamily.inter,
            fontSize: 13.0,
            color: AppColors.onSubSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(Assets.icons.google.svg(), false, () {}),
            const SizedBox(width: 12.0),
            _buildSocialButton(Assets.icons.telegram.svg(), true, () {}),
            const SizedBox(width: 12.0),
            _buildSocialButton(Assets.icons.apple.svg(), false, () {}),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton(Widget icon, bool isTelegram, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32.0,
        height: 32.0,
        decoration: BoxDecoration(
          gradient: isTelegram
              ? LinearGradient(
                  colors: [Color(0xFF2AABEE), Color(0xFF229ED9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isTelegram ? null : Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(child: icon),
      ),
    );
  }
}
