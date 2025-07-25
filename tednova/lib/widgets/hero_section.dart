import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_theme.dart';

class HeroSection extends StatefulWidget {
  final AnimationController animationController;

  const HeroSection({
    super.key,
    required this.animationController,
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  bool _showSubtext = false;
  bool _showButtons = false;

  @override
  void initState() {
    super.initState();

    // Trigger subtitle and buttons after main animation
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showSubtext = true);
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showButtons = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);

    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 48,
        vertical: 80,
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Main title with animated text
              _buildAnimatedTitle(isDesktop, isMobile),
              const SizedBox(height: 24),
              // Subtitle with typewriter effect
              if (_showSubtext) _buildSubtitle(isDesktop),
              const SizedBox(height: 48),
              // Action buttons
              if (_showButtons) _buildActionButtons(isDesktop),
              const SizedBox(height: 80),
              // Scroll indicator
              _buildScrollIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedTitle(bool isDesktop, bool isMobile) {
    return Column(
      children: [
        // Greeting
        Text(
          'Welcome to the Future',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.textSecondary,
                fontSize: isMobile ? 16 : 20,
              ),
        ).animate().fadeIn().slideY(begin: -0.3),

        const SizedBox(height: 16),

        // Main name with gradient
        ShaderMask(
          shaderCallback: (bounds) =>
              AppTheme.primaryGradient.createShader(bounds),
          child: Text(
            'TeddyNova',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: isMobile ? 48 : (isDesktop ? 72 : 56),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
            textAlign: TextAlign.center,
          ),
        ).animate().scale(delay: 300.ms, duration: 800.ms),

        const SizedBox(height: 24),

        // Animated role description
        SizedBox(
          height: isMobile ? 60 : 80,
          child: AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'AI/ML Engineer',
                textStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.primaryColor,
                      fontSize: isMobile ? 20 : (isDesktop ? 32 : 24),
                    ),
                speed: const Duration(milliseconds: 100),
              ),
              TypewriterAnimatedText(
                'AgriTech Innovator',
                textStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.accentColor,
                      fontSize: isMobile ? 20 : (isDesktop ? 32 : 24),
                    ),
                speed: const Duration(milliseconds: 100),
              ),
              TypewriterAnimatedText(
                'Space Technology Enthusiast',
                textStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.secondaryColor,
                      fontSize: isMobile ? 20 : (isDesktop ? 32 : 24),
                    ),
                speed: const Duration(milliseconds: 100),
              ),
            ],
            totalRepeatCount: 3,
            pause: const Duration(milliseconds: 1000),
            displayFullTextOnTap: true,
            stopPauseOnTap: true,
          ),
        ),
      ],
    );
  }

  Widget _buildSubtitle(bool isDesktop) {
    return Container(
      constraints: BoxConstraints(maxWidth: isDesktop ? 600 : 400),
      child: Text(
        'Exploring the intersection of artificial intelligence, sustainable agriculture, '
        'and space innovation to create solutions for tomorrow\'s challenges.',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textSecondary,
              height: 1.6,
            ),
        textAlign: TextAlign.center,
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3);
  }

  Widget _buildActionButtons(bool isDesktop) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        // Primary CTA
        ElevatedButton.icon(
          onPressed: () => context.go('/projects'),
          icon: const Icon(Icons.rocket_launch),
          label: const Text('Explore Projects'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.black,
          ),
        ).animate().scale(delay: 200.ms),

        // Secondary CTA
        OutlinedButton.icon(
          onPressed: () => context.go('/contact'),
          icon: const Icon(Icons.contact_mail),
          label: const Text('Get In Touch'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            side: const BorderSide(color: AppTheme.primaryColor),
            foregroundColor: AppTheme.primaryColor,
          ),
        ).animate().scale(delay: 400.ms),

        // Blog CTA
        TextButton.icon(
          onPressed: () => context.go('/blog'),
          icon: const Icon(Icons.article),
          label: const Text('Read Blog'),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            foregroundColor: AppTheme.accentColor,
          ),
        ).animate().scale(delay: 600.ms),
      ],
    );
  }

  Widget _buildScrollIndicator() {
    return Column(
      children: [
        Text(
          'Scroll to explore',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary.withOpacity(0.7),
              ),
        ),
        const SizedBox(height: 8),
        Icon(
          Icons.keyboard_arrow_down,
          color: AppTheme.primaryColor,
          size: 32,
        )
            .animate(onPlay: (controller) => controller.repeat())
            .moveY(begin: 0, end: 10, duration: 1.seconds)
            .then()
            .moveY(begin: 10, end: 0, duration: 1.seconds),
      ],
    ).animate().fadeIn(delay: 4.seconds);
  }
}
