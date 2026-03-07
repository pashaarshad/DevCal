import 'package:flutter/material.dart';
import '../widgets/tool_card.dart';

/// Home Screen — The main dashboard of DEVCal.
///
/// Displays a 2×2 grid of tool cards that navigate to each tool screen.
/// Features a modern header with greeting and staggered card animations.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // App Logo Row
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                theme.colorScheme.primary,
                                theme.colorScheme.primary.withOpacity(0.7),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.primary.withOpacity(
                                  0.3,
                                ),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              '</>',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DEVCal',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                            Text(
                              'Developer Calculator & Tools',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.5,
                                ),
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Section Label
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 20,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'TOOLS',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                            color: theme.colorScheme.onSurface.withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Tools Grid
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.95,
                ),
                delegate: SliverChildListDelegate([
                  ToolCard(
                    icon: Icons.calculate_rounded,
                    title: 'Calculator',
                    description: 'Basic arithmetic operations',
                    iconColor: const Color(0xFF1E88E5),
                    onTap: () => Navigator.pushNamed(context, '/calculator'),
                    animationDelay: 100,
                  ),
                  ToolCard(
                    icon: Icons.swap_horiz_rounded,
                    title: 'Converter',
                    description: 'Binary, Decimal, Hex, Octal',
                    iconColor: const Color(0xFF43A047),
                    onTap: () => Navigator.pushNamed(context, '/converter'),
                    animationDelay: 200,
                  ),
                  ToolCard(
                    icon: Icons.lock_rounded,
                    title: 'Base64 Tool',
                    description: 'Encode & decode Base64',
                    iconColor: const Color(0xFFFF7043),
                    onTap: () => Navigator.pushNamed(context, '/base64'),
                    animationDelay: 300,
                  ),
                  ToolCard(
                    icon: Icons.data_object_rounded,
                    title: 'JSON Formatter',
                    description: 'Beautify & validate JSON',
                    iconColor: const Color(0xFFAB47BC),
                    onTap: () =>
                        Navigator.pushNamed(context, '/json-formatter'),
                    animationDelay: 400,
                  ),
                ]),
              ),
            ),

            // Bottom branding
            SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Text(
                    'Made with ♥ for developers',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.25),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
