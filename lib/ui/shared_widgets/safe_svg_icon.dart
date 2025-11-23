import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SafeSvgIcon extends StatelessWidget {
  final String assetPath;
  final double width;
  final double height;
  final Color? color;
  final Widget fallback;

  const SafeSvgIcon({
    Key? key,
    required this.assetPath,
    required this.width,
    required this.height,
    this.color,
    required this.fallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      return SvgPicture.asset(
        assetPath,
        width: width,
        height: height,
        colorFilter: color != null
            ? ColorFilter.mode(color!, BlendMode.srcIn)
            : null,
        placeholderBuilder: (context) => fallback,
      );
    } catch (e) {
      return fallback;
    }
  }
}

