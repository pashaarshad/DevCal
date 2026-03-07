/// Utility class for number system conversions.
///
/// Supports conversions between Decimal, Binary, Octal, and Hexadecimal.
class ConverterUtils {
  /// Converts a decimal number string to binary.
  /// Returns 'Invalid input' if the input is not a valid decimal integer.
  static String decimalToBinary(String decimal) {
    try {
      final number = int.parse(decimal.trim());
      if (number < 0) {
        // Handle negative numbers with two's complement representation
        return '-${number.abs().toRadixString(2)}';
      }
      return number.toRadixString(2);
    } catch (e) {
      return 'Invalid input';
    }
  }

  /// Converts a binary number string to decimal.
  /// Returns 'Invalid input' if the input is not a valid binary string.
  static String binaryToDecimal(String binary) {
    try {
      final cleaned = binary.trim();
      if (!RegExp(r'^-?[01]+$').hasMatch(cleaned)) {
        return 'Invalid binary number';
      }
      final number = int.parse(cleaned, radix: 2);
      return number.toString();
    } catch (e) {
      return 'Invalid input';
    }
  }

  /// Converts a decimal number string to hexadecimal (uppercase).
  /// Returns 'Invalid input' if the input is not a valid decimal integer.
  static String decimalToHex(String decimal) {
    try {
      final number = int.parse(decimal.trim());
      if (number < 0) {
        return '-${number.abs().toRadixString(16).toUpperCase()}';
      }
      return number.toRadixString(16).toUpperCase();
    } catch (e) {
      return 'Invalid input';
    }
  }

  /// Converts a hexadecimal number string to decimal.
  /// Returns 'Invalid input' if the input is not a valid hex string.
  static String hexToDecimal(String hex) {
    try {
      final cleaned = hex.trim().replaceAll(
        RegExp(r'^0x', caseSensitive: false),
        '',
      );
      if (!RegExp(r'^-?[0-9a-fA-F]+$').hasMatch(cleaned)) {
        return 'Invalid hex number';
      }
      final number = int.parse(cleaned, radix: 16);
      return number.toString();
    } catch (e) {
      return 'Invalid input';
    }
  }

  /// Converts a decimal number string to octal.
  static String decimalToOctal(String decimal) {
    try {
      final number = int.parse(decimal.trim());
      if (number < 0) {
        return '-${number.abs().toRadixString(8)}';
      }
      return number.toRadixString(8);
    } catch (e) {
      return 'Invalid input';
    }
  }

  /// Converts an octal number string to decimal.
  static String octalToDecimal(String octal) {
    try {
      final cleaned = octal.trim();
      if (!RegExp(r'^-?[0-7]+$').hasMatch(cleaned)) {
        return 'Invalid octal number';
      }
      final number = int.parse(cleaned, radix: 8);
      return number.toString();
    } catch (e) {
      return 'Invalid input';
    }
  }
}
