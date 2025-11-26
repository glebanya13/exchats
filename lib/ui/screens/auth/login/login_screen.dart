import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:exchats/locator.dart';
import 'package:exchats/presentation/store/auth_store.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int _selectedTab = 0; 
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isPhoneValid = false;
  bool _isEmailValid = false;
  String? _phoneError;
  String? _emailError;

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
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
                    'Авторизация',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 32.0),

                  _buildTabs(theme),
                  const SizedBox(height: 24.0),

                  _selectedTab == 0
                      ? _buildPhoneInput(theme)
                      : _buildEmailInput(theme),
                  if ((_selectedTab == 0 && _phoneError != null) ||
                      (_selectedTab == 1 && _emailError != null))
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _selectedTab == 0 ? _phoneError! : _emailError!,
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
          ),
        ),
      ),
    );
  }

  Widget _buildTabs(ThemeData theme) {
    return Container(
      height: 44.0,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTab = 0;
                  _phoneError = null;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _selectedTab == 0 ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                  ),
                  border: _selectedTab == 0
                      ? Border.all(color: Colors.grey[300]!, width: 1.0)
                      : null,
                ),
                child: Center(
                  child: Text(
                    'Телефон',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: _selectedTab == 0
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
              onTap: () {
                setState(() {
                  _selectedTab = 1;
                  _emailError = null;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _selectedTab == 1 ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                  ),
                  border: _selectedTab == 1
                      ? Border.all(color: Colors.grey[300]!, width: 1.0)
                      : null,
                ),
                child: Center(
                  child: Text(
                    'Почта',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: _selectedTab == 1
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
    return TextField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(11),
      ],
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText: '',
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/auth/russian-federation.png',
                width: 20.0,
                height: 20.0,
                errorBuilder: (context, error, stackTrace) {
                  return Text(
                    '🇷🇺',
                    style: TextStyle(fontSize: 20.0),
                  );
                },
              ),
              const SizedBox(width: 8.0),
              Text(
                '+7',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 80.0),
        suffixIcon: _phoneController.text.isNotEmpty
            ? (_isPhoneValid && _phoneError == null
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
                : _phoneError != null
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
                    : null)
            : null,
        filled: true,
        fillColor: const Color(0xFFF0F1F3),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: _phoneError != null ? Colors.red : Colors.transparent,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: _phoneError != null ? Colors.red : theme.colorScheme.secondary,
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
        setState(() {
          _isPhoneValid = value.length == 11;
          if (value.length > 0 && value.length < 11) {
            _phoneError = 'Номер телефона заблокирован';
          } else if (value.length == 11) {
            _phoneError = null;
          } else {
            _phoneError = null;
          }
        });
      },
    );
  }

  Widget _buildEmailInput(ThemeData theme) {
    return TextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText: 'Введите почту',
        hintStyle: TextStyle(
          color: Colors.grey[400],
          fontSize: 16.0,
        ),
        filled: true,
        fillColor: const Color(0xFFF0F1F3),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: _emailError != null ? Colors.red : Colors.transparent,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: _emailError != null ? Colors.red : theme.colorScheme.secondary,
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
        setState(() {
          _isEmailValid = value.contains('@') && value.contains('.');
          if (value.isNotEmpty && !_isEmailValid) {
            _emailError = 'Неверный формат email';
          } else {
            _emailError = null;
          }
        });
      },
    );
  }

  Widget _buildNextButton(ThemeData theme) {
    final isValid = _selectedTab == 0 ? _isPhoneValid : _isEmailValid;
    final hasError = (_selectedTab == 0 && _phoneError != null) ||
        (_selectedTab == 1 && _emailError != null);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: (isValid && !hasError)
            ? () {
                if (_selectedTab == 0) {
                  final phoneNumber = '+7${_phoneController.text}';
                  context.push('/auth/verification?phoneNumber=$phoneNumber');
                } else {

                }
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isValid && !hasError
              ? const Color(0xFF1677FF)
              : const Color(0xFFF0F1F3),
          foregroundColor: isValid && !hasError ? Colors.white : Colors.grey[600],
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 0,
        ),
        child: Text(
          'Далее',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLogin(ThemeData theme) {
    return Column(
      children: [
        Text(
          'Или войти с помощью',
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.grey[600],
          ),
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

  Widget _buildSocialButton(String assetPath, bool isTelegram, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.0,
        height: 40.0,
        decoration: BoxDecoration(
          gradient: isTelegram
              ? LinearGradient(
                  colors: [
                    Color(0xFF2AABEE),
                    Color(0xFF229ED9),
                  ],
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
