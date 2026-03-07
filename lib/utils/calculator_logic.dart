import 'package:math_expressions/math_expressions.dart';

/// Evaluates mathematical expressions safely using the math_expressions package.
///
/// Returns the result as a formatted string. Handles errors gracefully
/// and returns 'Error' if the expression is invalid.
class CalculatorLogic {
  /// Evaluates the given [expression] string and returns the result.
  ///
  /// Supports: +, -, ×, ÷, decimal numbers, and parentheses.
  /// The expression is sanitized before evaluation:
  ///   - '×' is replaced with '*'
  ///   - '÷' is replaced with '/'
  static String evaluate(String expression) {
    try {
      // Sanitize display symbols to math operators
      String sanitized = expression
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll(',', '');

      // Don't evaluate empty expressions
      if (sanitized.trim().isEmpty) return '0';

      Parser parser = Parser();
      Expression exp = parser.parse(sanitized);
      ContextModel contextModel = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, contextModel);

      // Check for infinity / NaN (division by zero)
      if (result.isInfinite) return 'Cannot divide by zero';
      if (result.isNaN) return 'Error';

      // Format the result: remove trailing .0 for whole numbers
      if (result == result.roundToDouble() && !result.isInfinite) {
        // Check if it fits in an int
        if (result.abs() < 1e15) {
          return result.toInt().toString();
        }
      }

      // Format with reasonable precision
      String formatted = result.toStringAsPrecision(10);
      // Remove trailing zeros after decimal point
      if (formatted.contains('.')) {
        formatted = formatted.replaceAll(RegExp(r'0+$'), '');
        formatted = formatted.replaceAll(RegExp(r'\.$'), '');
      }

      return formatted;
    } catch (e) {
      return 'Error';
    }
  }
}
