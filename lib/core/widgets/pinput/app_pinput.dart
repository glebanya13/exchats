import 'package:exchats/core/assets/gen/fonts.gen.dart';
import 'package:exchats/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class AppPinput extends StatefulWidget {
  const AppPinput({
    super.key,
    this.length = 6,
    required this.onChanged,
    required this.onCompleted,
    this.showError = false,
  });

  final int length;
  final void Function(String) onChanged;
  final void Function(String) onCompleted;
  final bool showError;

  @override
  State<AppPinput> createState() => _AppPinputState();
}

class _AppPinputState extends State<AppPinput> {
  late TextEditingController _otpController;

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = AppColors.onSurface;
    final errorColor = AppColors.errorPrimary;
    final baseTextStyle = TextStyle(
      fontFamily: FontFamily.inter,
      fontSize: 13.0,
      color: AppColors.gray,
      fontWeight: FontWeight.w600,
    );
    final activeTextStyle = baseTextStyle.copyWith(color: activeColor);
    final errorTextStyle = baseTextStyle.copyWith(color: errorColor);
    final baseDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: AppColors.borderPrimary, width: 1),
    );
    final activeDecoration = baseDecoration.copyWith(
      border: Border.all(color: activeColor, width: 1),
    );
    final errorDecoration = baseDecoration.copyWith(
      border: Border.all(color: errorColor, width: 1),
    );
    final basePinTheme = PinTheme(
      constraints: const BoxConstraints(minWidth: 40),
      height: 40,

      textStyle: baseTextStyle,
      decoration: baseDecoration,
    );
    final activePinTheme = basePinTheme.copyWith(
      textStyle: activeTextStyle,
      decoration: activeDecoration,
    );
    final errorPinTheme = basePinTheme.copyWith(
      textStyle: errorTextStyle,
      decoration: errorDecoration,
    );

    return Pinput(
      controller: _otpController,
      length: widget.length,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      onChanged: widget.onChanged,
      separatorBuilder: (index) => const SizedBox(width: 8),
      onCompleted: (code) {
        widget.onCompleted(code);
      },
      defaultPinTheme: basePinTheme,
      focusedPinTheme: activePinTheme,
      submittedPinTheme: activePinTheme,
      errorPinTheme: errorPinTheme,
      forceErrorState: widget.showError,
      preFilledWidget: Text('•', style: baseTextStyle),
    );
  }
}
