import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/converter_utils.dart';

/// Number Converter Screen — Convert between Dec, Bin, Hex, and Octal.
///
/// Uses a segmented button to select conversion type and provides
/// instant conversion with copy-to-clipboard support.
class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

/// Available conversion types.
enum ConversionType {
  decToBin('Dec → Bin', 'Enter decimal number'),
  binToDec('Bin → Dec', 'Enter binary number'),
  decToHex('Dec → Hex', 'Enter decimal number'),
  hexToDec('Hex → Dec', 'Enter hex number'),
  decToOct('Dec → Oct', 'Enter decimal number'),
  octToDec('Oct → Dec', 'Enter octal number');

  final String label;
  final String hint;
  const ConversionType(this.label, this.hint);
}

class _ConverterScreenState extends State<ConverterScreen> {
  ConversionType _selectedType = ConversionType.decToBin;
  final TextEditingController _inputController = TextEditingController();
  String _output = '';
  bool _hasConverted = false;

  /// Performs the conversion based on [_selectedType].
  void _convert() {
    final input = _inputController.text.trim();
    if (input.isEmpty) {
      setState(() {
        _output = '';
        _hasConverted = false;
      });
      return;
    }

    String result;
    switch (_selectedType) {
      case ConversionType.decToBin:
        result = ConverterUtils.decimalToBinary(input);
        break;
      case ConversionType.binToDec:
        result = ConverterUtils.binaryToDecimal(input);
        break;
      case ConversionType.decToHex:
        result = ConverterUtils.decimalToHex(input);
        break;
      case ConversionType.hexToDec:
        result = ConverterUtils.hexToDecimal(input);
        break;
      case ConversionType.decToOct:
        result = ConverterUtils.decimalToOctal(input);
        break;
      case ConversionType.octToDec:
        result = ConverterUtils.octalToDecimal(input);
        break;
    }

    setState(() {
      _output = result;
      _hasConverted = true;
    });
  }

  /// Copies the output to the clipboard.
  void _copyOutput() {
    if (_output.isNotEmpty &&
        !_output.startsWith('Invalid') &&
        _output != 'Error') {
      Clipboard.setData(ClipboardData(text: _output));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Copied to clipboard'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Number Converter'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Conversion type selector
            _buildConversionChips(theme, isDark),
            const SizedBox(height: 24),

            // Input field
            TextField(
              controller: _inputController,
              onChanged: (_) {
                if (_hasConverted) _convert();
              },
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
              decoration: InputDecoration(
                hintText: _selectedType.hint,
                hintStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.3),
                  fontWeight: FontWeight.w400,
                ),
                filled: true,
                fillColor: isDark ? const Color(0xFF1E1E2E) : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.all(20),
                suffixIcon: _inputController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear_rounded,
                          color: theme.colorScheme.onSurface.withOpacity(0.4),
                        ),
                        onPressed: () {
                          _inputController.clear();
                          setState(() {
                            _output = '';
                            _hasConverted = false;
                          });
                        },
                      )
                    : null,
              ),
              keyboardType: _getKeyboardType(),
            ),
            const SizedBox(height: 16),

            // Convert button
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _convert,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shadowColor: theme.colorScheme.primary.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Convert',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Output area
            if (_hasConverted)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _output.startsWith('Invalid')
                        ? Colors.redAccent.withOpacity(0.3)
                        : theme.colorScheme.primary.withOpacity(0.15),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Result',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.4),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                        const Spacer(),
                        if (!_output.startsWith('Invalid'))
                          IconButton(
                            icon: Icon(
                              Icons.copy_rounded,
                              size: 20,
                              color: theme.colorScheme.primary,
                            ),
                            onPressed: _copyOutput,
                            tooltip: 'Copy',
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SelectableText(
                      _output,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: _output.startsWith('Invalid')
                            ? Colors.redAccent
                            : theme.colorScheme.onSurface,
                        letterSpacing: 1.5,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Builds the segmented conversion type selector.
  Widget _buildConversionChips(ThemeData theme, bool isDark) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: ConversionType.values.map((type) {
        final isSelected = _selectedType == type;
        return ChoiceChip(
          label: Text(
            type.label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? Colors.white
                  : theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          selected: isSelected,
          selectedColor: theme.colorScheme.primary,
          backgroundColor: isDark
              ? const Color(0xFF1E1E2E)
              : const Color(0xFFF0F2F5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide.none,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _selectedType = type;
                _output = '';
                _hasConverted = false;
                _inputController.clear();
              });
            }
          },
        );
      }).toList(),
    );
  }

  /// Returns the appropriate keyboard type for the current conversion.
  TextInputType _getKeyboardType() {
    switch (_selectedType) {
      case ConversionType.decToBin:
      case ConversionType.decToHex:
      case ConversionType.decToOct:
        return TextInputType.number;
      default:
        return TextInputType.text;
    }
  }
}
