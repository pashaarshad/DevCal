import 'package:flutter/material.dart';
import '../widgets/calc_button.dart';
import '../utils/calculator_logic.dart';

/// Calculator Screen — A modern, full-featured arithmetic calculator.
///
/// Features:
///   - Expression display (scrollable)
///   - Live result preview
///   - Standard arithmetic: +, -, ×, ÷
///   - Decimal support
///   - Clear, Backspace, Parentheses
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';
  String _result = '0';
  final ScrollController _scrollController = ScrollController();

  /// Appends a character to the expression.
  void _onInput(String value) {
    setState(() {
      _expression += value;
      _updateResult();
    });
    _scrollToEnd();
  }

  /// Removes the last character from the expression.
  void _onBackspace() {
    if (_expression.isNotEmpty) {
      setState(() {
        _expression = _expression.substring(0, _expression.length - 1);
        _updateResult();
      });
    }
  }

  /// Clears the expression and result.
  void _onClear() {
    setState(() {
      _expression = '';
      _result = '0';
    });
  }

  /// Evaluates the expression and displays the final result.
  void _onEquals() {
    if (_expression.isNotEmpty) {
      setState(() {
        _result = CalculatorLogic.evaluate(_expression);
        if (_result != 'Error' && _result != 'Cannot divide by zero') {
          _expression = _result;
        }
      });
    }
  }

  /// Updates the live preview result.
  void _updateResult() {
    if (_expression.isNotEmpty) {
      String preview = CalculatorLogic.evaluate(_expression);
      if (preview != 'Error') {
        _result = preview;
      }
    } else {
      _result = '0';
    }
  }

  /// Scrolls the expression display to the end.
  void _scrollToEnd() {
    Future.delayed(const Duration(milliseconds: 50), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Calculator'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          // Display Area
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Expression
                  SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Text(
                      _expression.isEmpty ? '0' : _expression,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w400,
                        color: theme.colorScheme.onSurface.withOpacity(
                          _expression.isEmpty ? 0.3 : 0.6,
                        ),
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Result
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      _result,
                      key: ValueKey(_result),
                      style: TextStyle(
                        fontSize: _result.length > 12 ? 36 : 48,
                        fontWeight: FontWeight.w700,
                        color:
                            _result == 'Error' ||
                                _result == 'Cannot divide by zero'
                            ? Colors.redAccent
                            : theme.colorScheme.onSurface,
                        letterSpacing: -1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Divider
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            height: 1,
            color: theme.colorScheme.onSurface.withOpacity(0.06),
          ),

          // Button Grid
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
              child: Column(
                children: [
                  // Row 1: C  ( )  ⌫
                  Expanded(
                    child: Row(
                      children: [
                        CalcButton(
                          text: 'C',
                          onTap: _onClear,
                          type: CalcButtonType.action,
                        ),
                        CalcButton(
                          text: '(',
                          onTap: () => _onInput('('),
                          type: CalcButtonType.action,
                        ),
                        CalcButton(
                          text: ')',
                          onTap: () => _onInput(')'),
                          type: CalcButtonType.action,
                        ),
                        CalcButton(
                          text: '⌫',
                          onTap: _onBackspace,
                          type: CalcButtonType.action,
                        ),
                      ],
                    ),
                  ),
                  // Row 2: 7 8 9 ÷
                  Expanded(
                    child: Row(
                      children: [
                        CalcButton(text: '7', onTap: () => _onInput('7')),
                        CalcButton(text: '8', onTap: () => _onInput('8')),
                        CalcButton(text: '9', onTap: () => _onInput('9')),
                        CalcButton(
                          text: '÷',
                          onTap: () => _onInput('÷'),
                          type: CalcButtonType.operator,
                        ),
                      ],
                    ),
                  ),
                  // Row 3: 4 5 6 ×
                  Expanded(
                    child: Row(
                      children: [
                        CalcButton(text: '4', onTap: () => _onInput('4')),
                        CalcButton(text: '5', onTap: () => _onInput('5')),
                        CalcButton(text: '6', onTap: () => _onInput('6')),
                        CalcButton(
                          text: '×',
                          onTap: () => _onInput('×'),
                          type: CalcButtonType.operator,
                        ),
                      ],
                    ),
                  ),
                  // Row 4: 1 2 3 −
                  Expanded(
                    child: Row(
                      children: [
                        CalcButton(text: '1', onTap: () => _onInput('1')),
                        CalcButton(text: '2', onTap: () => _onInput('2')),
                        CalcButton(text: '3', onTap: () => _onInput('3')),
                        CalcButton(
                          text: '−',
                          onTap: () => _onInput('-'),
                          type: CalcButtonType.operator,
                        ),
                      ],
                    ),
                  ),
                  // Row 5: 0 . = +
                  Expanded(
                    child: Row(
                      children: [
                        CalcButton(text: '0', onTap: () => _onInput('0')),
                        CalcButton(text: '.', onTap: () => _onInput('.')),
                        CalcButton(
                          text: '=',
                          onTap: _onEquals,
                          type: CalcButtonType.equals,
                        ),
                        CalcButton(
                          text: '+',
                          onTap: () => _onInput('+'),
                          type: CalcButtonType.operator,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
