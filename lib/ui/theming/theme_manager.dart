import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exchats/ui/theming/theme_provider.dart';

typedef ThemeBuilder = Widget Function(BuildContext, ThemeData? theme);

class ThemeManager extends StatefulWidget {
  ThemeManager({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final ThemeBuilder builder;

  @override
  ThemeManagerState createState() => ThemeManagerState();

  static ThemeManagerState of(BuildContext context) {
    final ThemeManagerState? result =
        context.findAncestorStateOfType<ThemeManagerState>();
    if (result != null) {
      return result;
    }

    throw FlutterError.fromParts(
      <DiagnosticsNode>[
        ErrorSummary(
            'ThemeManager.of() called with a context that does not contain a ThemeManager.'),
      ],
    );
  }
}

class ThemeManagerState extends State<ThemeManager> {
  AppTheme get currentTheme => context.read<ThemeProvider>().theme;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, _) {
        return widget.builder(context, provider.theme.data);
      },
    );
  }
}
