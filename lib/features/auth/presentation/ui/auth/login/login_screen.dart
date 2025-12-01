import 'package:easy_localization/easy_localization.dart';
import 'package:exchats/features/auth/presentation/store/login_store.dart';
import 'package:exchats/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  @override
  void initState() {
    super.initState();
    store = locator<LoginStore>();
    store.setupValidations();
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
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10.0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/auth/logo.png',
                        width: 64.0,
                        height: 64.0,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 64.0,
                            height: 64.0,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.image, size: 32.0),
                          );
                        },
                      ),
                      const SizedBox(height: 24.0),
                      Text(
                        LocaleKeys.auth_login_title.tr(),
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 32.0),
                      _buildTabs(theme),
                      const SizedBox(height: 24.0),
                      store.selectedTab == 0
                          ? _buildPhoneInput(theme)
                          : _buildEmailInput(theme),
                      if (store.hasError)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 0),
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
                      const SizedBox(height: 24.0),
                      _buildNextButton(theme),
                      const SizedBox(height: 24.0),
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

  Widget _buildTabs(ThemeData theme) {
    return Container(
      height: 44.0,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => store.setSelectedTab(0),
              child: Container(
                decoration: BoxDecoration(
                  color: store.selectedTab == 0
                      ? Colors.white
                      : Colors.transparent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                  ),
                  border: store.selectedTab == 0
                      ? Border.all(color: Colors.grey[300]!, width: 1.0)
                      : null,
                ),
                child: Center(
                  child: Text(
                    LocaleKeys.auth_login_phone.tr(),
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: store.selectedTab == 0
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => store.setSelectedTab(1),
              child: Container(
                decoration: BoxDecoration(
                  color: store.selectedTab == 1
                      ? Colors.white
                      : Colors.transparent,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                  ),
                  border: store.selectedTab == 1
                      ? Border.all(color: Colors.grey[300]!, width: 1.0)
                      : null,
                ),
                child: Center(
                  child: Text(
                    LocaleKeys.auth_login_email.tr(),
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: store.selectedTab == 1
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneInput(ThemeData theme) {
    final dialCode = '+${store.selectedCountry.phoneCode}';
    return TextField(
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
                  child: SvgPicture.asset(
                    'assets/auth/accept.svg',
                    width: 24.0,
                    height: 24.0,
                  ),
                ),
              )
            : store.hasError
            ? Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Transform.scale(
                  scale: 0.65,
                  child: SvgPicture.asset(
                    'assets/auth/error.svg',
                    width: 24.0,
                    height: 24.0,
                  ),
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
          style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
        ),
        const SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton('assets/auth/google.png', false, () {}),
            const SizedBox(width: 16.0),
            _buildSocialButton('assets/auth/tg_white.png', true, () {}),
            const SizedBox(width: 16.0),
            _buildSocialButton('assets/auth/apple.png', false, () {}),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton(
    String assetPath,
    bool isTelegram,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.0,
        height: 40.0,
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
          border: isTelegram
              ? null
              : Border.all(color: Colors.grey[300]!, width: 1.0),
        ),
        child: Center(
          child: Image.asset(
            assetPath,
            width: 32.0,
            height: 32.0,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.image, size: 32.0);
            },
          ),
        ),
      ),
    );
  }
}
