import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_theme.dart';

class CosmicBackground extends StatefulWidget {
  const CosmicBackground({super.key});

  @override
  State<CosmicBackground> createState() => _CosmicBackgroundState();
}

class _CosmicBackgroundState extends State<CosmicBackground>
    with TickerProviderStateMixin {
  late AnimationController _starsController;
  late AnimationController _nebulaeController;
  List<Star> stars = [];

  @override
  void initState() {
    super.initState();
    _starsController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    _nebulaeController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    );

    _generateStars();
    _starsController.repeat();
    _nebulaeController.repeat();
  }

  void _generateStars() {
    final random = math.Random();
    stars = List.generate(100, (index) {
      return Star(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 3 + 1,
        opacity: random.nextDouble() * 0.8 + 0.2,
        twinkleSpeed: random.nextDouble() * 2 + 1,
      );
    });
  }

  @override
  void dispose() {
    _starsController.dispose();
    _nebulaeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0A0A0F), // Deep space black
            Color(0xFF1A1A2E), // Dark purple
            Color(0xFF16213E), // Darker blue
            Color(0xFF0A0A0F), // Back to deep space
          ],
          stops: [0.0, 0.3, 0.7, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Nebulae background
          AnimatedBuilder(
            animation: _nebulaeController,
            builder: (context, child) {
              return CustomPaint(
                size: Size.infinite,
                painter: NebulaePainter(_nebulaeController.value),
              );
            },
          ),
          
          // Stars
          AnimatedBuilder(
            animation: _starsController,
            builder: (context, child) {
              return CustomPaint(
                size: Size.infinite,
                painter: StarsPainter(stars, _starsController.value),
              );
            },
          ),
          
          // Gradient overlay for depth
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [
                  Colors.transparent,
                  AppTheme.backgroundColor.withOpacity(0.3),
                  AppTheme.backgroundColor.withOpacity(0.7),
                ],
                stops: const [0.0, 0.7, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Star {
  final double x;
  final double y;
  final double size;
  final double opacity;
  final double twinkleSpeed;

  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.twinkleSpeed,
  });
}

class StarsPainter extends CustomPainter {
  final List<Star> stars;
  final double animationValue;

  StarsPainter(this.stars, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (final star in stars) {
      final paint = Paint()
        ..color = AppTheme.textPrimary.withOpacity(
          star.opacity * (0.5 + 0.5 * math.sin(animationValue * star.twinkleSpeed * math.pi * 2))
        )
        ..style = PaintingStyle.fill;

      final center = Offset(
        star.x * size.width,
        star.y * size.height,
      );

      // Draw star
      canvas.drawCircle(center, star.size, paint);
      
      // Draw star glow
      final glowPaint = Paint()
        ..color = AppTheme.primaryColor.withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      
      canvas.drawCircle(center, star.size * 1.5, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class NebulaePainter extends CustomPainter {
  final double animationValue;

  NebulaePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 50);

    // Nebula 1 - Purple
    paint.color = AppTheme.secondaryColor.withOpacity(0.1);
    final center1 = Offset(
      size.width * 0.2 + math.sin(animationValue * math.pi * 2) * 50,
      size.height * 0.3 + math.cos(animationValue * math.pi * 2) * 30,
    );
    canvas.drawCircle(center1, 150, paint);

    // Nebula 2 - Cyan
    paint.color = AppTheme.primaryColor.withOpacity(0.08);
    final center2 = Offset(
      size.width * 0.8 + math.cos(animationValue * math.pi * 2 * 0.7) * 40,
      size.height * 0.6 + math.sin(animationValue * math.pi * 2 * 0.7) * 60,
    );
    canvas.drawCircle(center2, 200, paint);

    // Nebula 3 - Green
    paint.color = AppTheme.accentColor.withOpacity(0.06);
    final center3 = Offset(
      size.width * 0.6 + math.sin(animationValue * math.pi * 2 * 0.5) * 70,
      size.height * 0.1 + math.cos(animationValue * math.pi * 2 * 0.5) * 40,
    );
    canvas.drawCircle(center3, 120, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}