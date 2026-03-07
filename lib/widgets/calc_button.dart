import 'package:flutter/material.dart';

/// A calculator button widget with modern styling.
///
/// Supports different visual styles via [type]:
///   - number: Standard number buttons
///   - operator: Operator buttons (+, -, ×, ÷)
///   - action: Special action buttons (C, ⌫, =)
///
/// Features smooth ripple animation and responsive sizing.
class CalcButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final CalcButtonType type;
  final int flex;

  const CalcButton({
    super.key,
    required this.text,
    required this.onTap,
    this.type = CalcButtonType.number,
    this.flex = 1,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Colors based on button type
    Color bgColor;
    Color textColor;
    double fontSize;

    switch (type) {
      case CalcButtonType.operator:
        bgColor = theme.colorScheme.primary.withOpacity(isDark ? 0.2 : 0.1);
        textColor = theme.colorScheme.primary;
        fontSize = 26;
        break;
      case CalcButtonType.action:
        bgColor = isDark ? const Color(0xFF2A2A3A) : const Color(0xFFE8EAF0);
        textColor = theme.colorScheme.onSurface.withOpacity(0.8);
        fontSize = 20;
        break;
      case CalcButtonType.equals:
        bgColor = theme.colorScheme.primary;
        textColor = Colors.white;
        fontSize = 28;
        break;
      case CalcButtonType.number:
        bgColor = isDark ? const Color(0xFF1E1E2E) : Colors.white;
        textColor = theme.colorScheme.onSurface;
        fontSize = 24;
        break;
    }

    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Material(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          elevation: type == CalcButtonType.equals ? 4 : 0,
          shadowColor: type == CalcButtonType.equals
              ? theme.colorScheme.primary.withOpacity(0.4)
              : Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            splashColor: theme.colorScheme.primary.withOpacity(0.15),
            highlightColor: theme.colorScheme.primary.withOpacity(0.05),
            child: Container(
              height: 68,
              alignment: Alignment.center,
              child: Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  letterSpacing: text.length > 1 ? -0.5 : 0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Button types for visual differentiation.
enum CalcButtonType { number, operator, action, equals }
