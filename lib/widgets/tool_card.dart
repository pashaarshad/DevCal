import 'package:flutter/material.dart';

/// A modern, animated tool card widget for the dashboard grid.
///
/// Displays an icon, title, and description. Taps trigger [onTap].
/// Features smooth scale animation on tap and elevation transitions.
class ToolCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;
  final Color? iconColor;
  final int animationDelay;

  const ToolCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
    this.iconColor,
    this.animationDelay = 0,
  });

  @override
  State<ToolCard> createState() => _ToolCardState();
}

class _ToolCardState extends State<ToolCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Staggered entrance animation
    Future.delayed(Duration(milliseconds: widget.animationDelay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E2E) : Colors.white;
    final iconBgColor = (widget.iconColor ?? theme.colorScheme.primary)
        .withOpacity(isDark ? 0.15 : 0.08);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
            transform: Matrix4.identity()..scale(_isPressed ? 0.95 : 1.0),
            transformAlignment: Alignment.center,
            child: Card(
              elevation: _isPressed ? 1 : 4,
              shadowColor: (widget.iconColor ?? theme.colorScheme.primary)
                  .withOpacity(0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: cardColor,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: widget.onTap,
                splashColor: (widget.iconColor ?? theme.colorScheme.primary)
                    .withOpacity(0.1),
                highlightColor: (widget.iconColor ?? theme.colorScheme.primary)
                    .withOpacity(0.05),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon with background circle
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: iconBgColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          widget.icon,
                          color: widget.iconColor ?? theme.colorScheme.primary,
                          size: 26,
                        ),
                      ),
                      const Spacer(),
                      // Title
                      Text(
                        widget.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Description
                      Text(
                        widget.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
