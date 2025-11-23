import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:exchats/ui/router.dart';
import 'package:exchats/ui/screens/auth/router.dart';

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
    // Set test code 111111
    WidgetsBinding.instance!.addPostFrameCallback((_) {
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
      backgroundColor: const Color(0xFFF5F5F5),
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
                  // Logo
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
                  // Title
                  Text(
                    'Код верификации',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  // White card starts here - no padding, just color separation
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Instruction or error - starts the white card
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
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
                              // Code input fields
                              _buildCodeInputs(theme),
                              const SizedBox(height: 32.0),
                              // Login button
                              _buildLoginButton(theme),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  // Terms link - outside white card
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
        final hasValue = _controllers[index].text.isNotEmpty;
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

  void _checkCode() {
    final code = _controllers.map((c) => c.text).join();
    setState(() {
      _isCodeComplete = code.length == 6;
      if (_isCodeComplete) {
        // Simulate code verification
        if (code == '111111' || code == '123456') {
          _errorMessage = null;
          // Navigate to home or profile creation
          Navigator.of(context, rootNavigator: true)
              .pushReplacementNamed(AppRoutes.Home);
        } else {
          _errorMessage = 'Не верно указанный код';
        }
      } else {
        _errorMessage = null;
      }
    });
  }

  Widget _buildLoginButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isCodeComplete && _errorMessage == null
            ? () {
                final code = _controllers.map((c) => c.text).join();
                if (code == '111111' || code == '123456') {
                  Navigator.of(context, rootNavigator: true)
                      .pushReplacementNamed(AppRoutes.Home);
                } else {
                  setState(() {
                    _errorMessage = 'Не верно указанный код';
                  });
                }
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
      onTap: () {
        // TODO: Show terms
      },
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
