import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// JSON Formatter Screen — Beautify and validate JSON strings.
///
/// Features:
///   - Input JSON text area
///   - Format and Minify buttons
///   - Pretty-printed output with syntax-aware styling
///   - Error reporting for invalid JSON
///   - Copy formatted output to clipboard
class JsonFormatterScreen extends StatefulWidget {
  const JsonFormatterScreen({super.key});

  @override
  State<JsonFormatterScreen> createState() => _JsonFormatterScreenState();
}

class _JsonFormatterScreenState extends State<JsonFormatterScreen> {
  final TextEditingController _inputController = TextEditingController();
  String _output = '';
  bool _isError = false;
  bool _isFormatted = false;

  /// Formats (beautifies) the JSON input.
  void _formatJson() {
    final input = _inputController.text.trim();
    if (input.isEmpty) {
      _showSnackBar('Please enter JSON to format');
      return;
    }

    try {
      final dynamic parsed = jsonDecode(input);
      final encoder = const JsonEncoder.withIndent('  ');
      setState(() {
        _output = encoder.convert(parsed);
        _isError = false;
        _isFormatted = true;
      });
    } catch (e) {
      setState(() {
        _output =
            'Invalid JSON: ${e.toString().replaceAll('FormatException: ', '')}';
        _isError = true;
        _isFormatted = false;
      });
    }
  }

  /// Minifies (compacts) the JSON input.
  void _minifyJson() {
    final input = _inputController.text.trim();
    if (input.isEmpty) {
      _showSnackBar('Please enter JSON to minify');
      return;
    }

    try {
      final dynamic parsed = jsonDecode(input);
      setState(() {
        _output = jsonEncode(parsed);
        _isError = false;
        _isFormatted = true;
      });
    } catch (e) {
      setState(() {
        _output =
            'Invalid JSON: ${e.toString().replaceAll('FormatException: ', '')}';
        _isError = true;
        _isFormatted = false;
      });
    }
  }

  /// Copies the output to clipboard.
  void _copyOutput() {
    if (_output.isNotEmpty && !_isError) {
      Clipboard.setData(ClipboardData(text: _output));
      _showSnackBar('Copied to clipboard');
    }
  }

  /// Pastes from clipboard into the input area.
  void _pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null && data!.text!.isNotEmpty) {
      setState(() {
        _inputController.text = data.text!;
      });
    }
  }

  /// Clears both input and output.
  void _clearAll() {
    setState(() {
      _inputController.clear();
      _output = '';
      _isError = false;
      _isFormatted = false;
    });
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
        title: const Text('JSON Formatter'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.paste_rounded, color: theme.colorScheme.primary),
            onPressed: _pasteFromClipboard,
            tooltip: 'Paste from clipboard',
          ),
          IconButton(
            icon: Icon(
              Icons.delete_outline_rounded,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            onPressed: _clearAll,
            tooltip: 'Clear all',
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input Label
            _buildLabel(theme, 'INPUT JSON'),
            const SizedBox(height: 8),

            // Input text area
            TextField(
              controller: _inputController,
              maxLines: 8,
              minLines: 5,
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'monospace',
                color: theme.colorScheme.onSurface,
                height: 1.6,
              ),
              decoration: InputDecoration(
                hintText: '{\n  "key": "value"\n}',
                hintStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.2),
                  fontFamily: 'monospace',
                  fontSize: 13,
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
            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _formatJson,
                      icon: const Icon(Icons.auto_fix_high_rounded, size: 20),
                      label: const Text(
                        'Beautify',
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
                      onPressed: _minifyJson,
                      icon: const Icon(Icons.compress_rounded, size: 20),
                      label: const Text(
                        'Minify',
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
                  _buildLabel(theme, 'OUTPUT'),
                  const Spacer(),
                  if (!_isError)
                    IconButton(
                      icon: Icon(
                        Icons.copy_rounded,
                        size: 20,
                        color: theme.colorScheme.primary,
                      ),
                      onPressed: _copyOutput,
                      tooltip: 'Copy output',
                    ),
                ],
              ),
              const SizedBox(height: 8),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1A1A2E)
                      : const Color(0xFFFAFBFC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _isError
                        ? Colors.redAccent.withOpacity(0.3)
                        : theme.colorScheme.primary.withOpacity(0.1),
                    width: 1.5,
                  ),
                ),
                child: SelectableText(
                  _output,
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'monospace',
                    color: _isError
                        ? Colors.redAccent
                        : theme.colorScheme.onSurface,
                    height: 1.6,
                  ),
                ),
              ),
            ],

            // Validation status indicator
            if (_isFormatted && !_isError) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF43A047).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: const Color(0xFF43A047),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Valid JSON',
                      style: TextStyle(
                        color: const Color(0xFF43A047),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Builds a section label.
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
