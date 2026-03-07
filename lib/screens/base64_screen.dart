import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Base64 Tool Screen — Encode and decode Base64 strings.
///
/// Features:
///   - Text input area
///   - Encode / Decode buttons
///   - Output display with copy-to-clipboard
///   - Error handling for invalid Base64 input
class Base64Screen extends StatefulWidget {
  const Base64Screen({super.key});

  @override
  State<Base64Screen> createState() => _Base64ScreenState();
}

class _Base64ScreenState extends State<Base64Screen> {
  final TextEditingController _inputController = TextEditingController();
  String _output = '';
  bool _isError = false;
  String _lastAction = '';

  /// Encodes the input text to Base64.
  void _encode() {
    final input = _inputController.text;
    if (input.isEmpty) {
      _showSnackBar('Please enter text to encode');
      return;
    }
    setState(() {
      _output = base64Encode(utf8.encode(input));
      _isError = false;
      _lastAction = 'Encoded';
    });
  }

  /// Decodes the input Base64 string to plain text.
  void _decode() {
    final input = _inputController.text.trim();
    if (input.isEmpty) {
      _showSnackBar('Please enter Base64 to decode');
      return;
    }
    try {
      final decoded = utf8.decode(base64Decode(input));
      setState(() {
        _output = decoded;
        _isError = false;
        _lastAction = 'Decoded';
      });
    } catch (e) {
      setState(() {
        _output = 'Invalid Base64 input';
        _isError = true;
        _lastAction = '';
      });
    }
  }

  /// Copies the output to the clipboard.
  void _copyOutput() {
    if (_output.isNotEmpty && !_isError) {
      Clipboard.setData(ClipboardData(text: _output));
      _showSnackBar('Copied to clipboard');
    }
  }

  /// Swaps the output into the input field.
  void _swapToInput() {
    if (_output.isNotEmpty && !_isError) {
      setState(() {
        _inputController.text = _output;
        _output = '';
        _lastAction = '';
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 1),
      ),
    );
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
        title: const Text('Base64 Tool'),
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
            // Input Label
            _buildLabel(theme, 'INPUT'),
            const SizedBox(height: 8),

            // Input text area
            TextField(
              controller: _inputController,
              maxLines: 6,
              minLines: 4,
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'monospace',
                color: theme.colorScheme.onSurface,
                height: 1.5,
              ),
              decoration: InputDecoration(
                hintText: 'Enter text or Base64 string...',
                hintStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.3),
                  fontFamily: 'monospace',
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
              ),
            ),
            const SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _encode,
                      icon: const Icon(Icons.lock_outline_rounded, size: 20),
                      label: const Text(
                        'Encode',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: theme.colorScheme.primary.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: _decode,
                      icon: const Icon(Icons.lock_open_rounded, size: 20),
                      label: const Text(
                        'Decode',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.colorScheme.primary,
                        side: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Output area
            if (_output.isNotEmpty) ...[
              Row(
                children: [
                  _buildLabel(
                    theme,
                    _lastAction.isNotEmpty ? '$_lastAction OUTPUT' : 'OUTPUT',
                  ),
                  const Spacer(),
                  if (!_isError) ...[
                    IconButton(
                      icon: Icon(
                        Icons.swap_vert_rounded,
                        size: 20,
                        color: theme.colorScheme.primary,
                      ),
                      onPressed: _swapToInput,
                      tooltip: 'Use as input',
                    ),
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
                ],
              ),
              const SizedBox(height: 8),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _isError
                        ? Colors.redAccent.withOpacity(0.3)
                        : theme.colorScheme.primary.withOpacity(0.15),
                    width: 1.5,
                  ),
                ),
                child: SelectableText(
                  _output,
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'monospace',
                    color: _isError
                        ? Colors.redAccent
                        : theme.colorScheme.onSurface,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Builds a section label widget.
  Widget _buildLabel(ThemeData theme, String text) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: theme.colorScheme.onSurface.withOpacity(0.4),
          ),
        ),
      ],
    );
  }
}
