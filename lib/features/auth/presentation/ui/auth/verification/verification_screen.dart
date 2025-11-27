import 'package:flutter/material.dart';
import 'package:exchats/core/constants/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/di/locator.dart';
import '../../../store/auth_store.dart';

class VerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const VerificationScreen({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  String? _errorMessage;
  bool _isCodeComplete = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (int i = 0; i < 6; i++) {
        _controllers[i].text = '1';
      }
      setState(() {
        _isCodeComplete = true;
      });
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
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
                    'Код верификации',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                          child: Text(
                            _errorMessage != null
                                ? _errorMessage!
                                : 'Введите 6-ти значный код.',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: _errorMessage != null
                                  ? Colors.red
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              _buildCodeInputs(theme),
                              const SizedBox(height: 32.0),
                              _buildLoginButton(theme),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  _buildTermsLink(theme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCodeInputs(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 34.0,
          height: 40.0,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              height: 1.2,
            ),
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: _errorMessage != null
                  ? Colors.red.withOpacity(0.1)
                  : Colors.white,
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: _errorMessage != null
                      ? Colors.red
                      : const Color(0xFFE1E7F1),
                  width: 1.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: _errorMessage != null
                      ? Colors.red
                      : const Color(0xFFE1E7F1),
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: _errorMessage != null
                      ? Colors.red
                      : theme.colorScheme.secondary,
                  width: 2.0,
                ),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                if (index < 5) {
                  _focusNodes[index + 1].requestFocus();
                } else {
                  _focusNodes[index].unfocus();
                }
              } else if (index > 0) {
                _focusNodes[index - 1].requestFocus();
              }
              _checkCode();
            },
          ),
        );
      }),
    );
  }

  Future<void> _checkCode() async {
    final code = _controllers.map((c) => c.text).join();
    if (!mounted) return;
    setState(() {
      _isCodeComplete = code.length == 6;
    });

    if (_isCodeComplete) {
      try {
        final authStore = locator<AuthStore>();
        await authStore.verifyCode(
          phoneNumber: widget.phoneNumber,
          code: code,
        );
        if (!mounted) return;
        context.go('/');
      } catch (e) {
        if (!mounted) return;
        setState(() {
          _errorMessage = 'Неверный или просроченный код';
        });
      }
    } else {
      if (!mounted) return;
      setState(() {
        _errorMessage = null;
      });
    }
  }

  Widget _buildLoginButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isCodeComplete && _errorMessage == null
            ? () async {
                await _checkCode();
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isCodeComplete && _errorMessage == null
              ? theme.colorScheme.secondary
              : const Color(0xFFE0E0E0),
          foregroundColor: _isCodeComplete && _errorMessage == null
              ? Colors.white
              : Colors.grey[600],
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 0,
        ),
        child: Text(
          'Вход',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildTermsLink(ThemeData theme) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        'Условия публичной оферты',
        style: TextStyle(
          fontSize: 12.0,
          color: Colors.grey[600],
          decoration: TextDecoration.underline,
          decorationStyle: TextDecorationStyle.dotted,
        ),
      ),
    );
  }
}
