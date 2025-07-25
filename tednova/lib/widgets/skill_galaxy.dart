import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'dart:math' as math;
import '../constants/app_theme.dart';

class SkillGalaxy extends StatefulWidget {
  const SkillGalaxy({super.key});

  @override
  State<SkillGalaxy> createState() => _SkillGalaxyState();
}

class _SkillGalaxyState extends State<SkillGalaxy>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  String _hoveredSkill = '';

  final List<SkillOrb> _skills = [
    SkillOrb('Flutter', Icons.flutter_dash, AppTheme.primaryColor, 0.9, 1.2),
    SkillOrb('Python', Icons.code, AppTheme.accentColor, 0.8, 1.0),
    SkillOrb('TensorFlow', Icons.psychology, AppTheme.secondaryColor, 0.85, 1.1),
    SkillOrb('Firebase', Icons.cloud, AppTheme.warningColor, 0.7, 0.9),
    SkillOrb('IoT', Icons.sensors, AppTheme.primaryColor, 0.75, 0.8),
    SkillOrb('Agriculture', Icons.eco, AppTheme.successColor, 0.9, 1.3),
    SkillOrb('Space Tech', Icons.rocket, AppTheme.accentColor, 0.8, 1.1),
    SkillOrb('AI/ML', Icons.auto_awesome, AppTheme.primaryColor, 0.95, 1.4),
    SkillOrb('Drones', Icons.flight, AppTheme.secondaryColor, 0.7, 0.7),
    SkillOrb('Research', Icons.science, AppTheme.warningColor, 0.8, 1.0),
  ];

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 60),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _rotationController.repeat();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    final isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 48,
        vertical: 80,
      ),
      child: Column(
        children: [
          // Section title
          Text(
            'Skill Galaxy',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontSize: isMobile ? 28 : 36,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn().slideY(begin: -0.3),

          const SizedBox(height: 16),

          Text(
            'Navigate through my constellation of technical expertise',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 200.ms),

          const SizedBox(height: 60),

          // Galaxy container
          Container(
            height: isMobile ? 400 : (isDesktop ? 600 : 500),
            width: double.infinity,
            child: AnimatedBuilder(
              animation: Listenable.merge([_rotationController, _pulseController]),
              builder: (context, child) {
                return CustomPaint(
                  size: Size.infinite,
                  painter: SkillGalaxyPainter(
                    skills: _skills,
                    rotationValue: _rotationController.value,
                    pulseValue: _pulseController.value,
                    hoveredSkill: _hoveredSkill,
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 40),

          // Skills legend
          _buildSkillsLegend(isMobile),
        ],
      ),
    );
  }

  Widget _buildSkillsLegend(bool isMobile) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: _skills.map((skill) {
        final isHovered = _hoveredSkill == skill.name;
        
        return MouseRegion(
          onEnter: (_) => setState(() => _hoveredSkill = skill.name),
          onExit: (_) => setState(() => _hoveredSkill = ''),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isHovered 
                  ? skill.color.withOpacity(0.2)
                  : AppTheme.surfaceColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isHovered ? skill.color : Colors.transparent,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  skill.icon,
                  color: skill.color,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  skill.name,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isHovered ? skill.color : AppTheme.textSecondary,
                    fontWeight: isHovered ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ).animate().scale(delay: (_skills.indexOf(skill) * 100).ms);
      }).toList(),
    );
  }
}

class SkillOrb {
  final String name;
  final IconData icon;
  final Color color;
  final double distance;
  final double size;

  SkillOrb(this.name, this.icon, this.color, this.distance, this.size);
}

class SkillGalaxyPainter extends CustomPainter {
  final List<SkillOrb> skills;
  final double rotationValue;
  final double pulseValue;
  final String hoveredSkill;

  SkillGalaxyPainter({
    required this.skills,
    required this.rotationValue,
    required this.pulseValue,
    required this.hoveredSkill,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.min(size.width, size.height) / 2 - 50;

    // Draw orbital paths
    _drawOrbitalPaths(canvas, center, maxRadius);

    // Draw skill orbs
    for (int i = 0; i < skills.length; i++) {
      final skill = skills[i];
      final angle = (rotationValue * 2 * math.pi) + (i * 2 * math.pi / skills.length);
      final radius = maxRadius * skill.distance;
      
      final orbPosition = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );

      _drawSkillOrb(canvas, orbPosition, skill, hoveredSkill == skill.name);
    }

    // Draw center core
    _drawCenterCore(canvas, center);
  }

  void _drawOrbitalPaths(Canvas canvas, Offset center, double maxRadius) {
    final pathPaint = Paint()
      ..color = AppTheme.primaryColor.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw multiple orbital rings
    for (double distance = 0.3; distance <= 1.0; distance += 0.2) {
      canvas.drawCircle(center, maxRadius * distance, pathPaint);
    }
  }

  void _drawSkillOrb(Canvas canvas, Offset position, SkillOrb skill, bool isHovered) {
    final baseSize = 20.0 * skill.size;
    final currentSize = baseSize + (pulseValue * 5) + (isHovered ? 10 : 0);
    
    // Outer glow
    final glowPaint = Paint()
      ..color = skill.color.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    
    canvas.drawCircle(position, currentSize * 1.5, glowPaint);

    // Main orb
    final orbPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          skill.color.withOpacity(0.8),
          skill.color.withOpacity(0.4),
          skill.color.withOpacity(0.1),
        ],
        stops: const [0.0, 0.7, 1.0],
      ).createShader(Rect.fromCircle(center: position, radius: currentSize));

    canvas.drawCircle(position, currentSize, orbPaint);

    // Inner core
    final corePaint = Paint()
      ..color = skill.color
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(position, currentSize * 0.3, corePaint);

    // Skill name (if hovered)
    if (isHovered) {
      _drawSkillLabel(canvas, position, skill.name, currentSize);
    }
  }

  void _drawCenterCore(Canvas canvas, Offset center) {
    // Core glow
    final glowPaint = Paint()
      ..color = AppTheme.primaryColor.withOpacity(0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    
    canvas.drawCircle(center, 40, glowPaint);

    // Core gradient
    final corePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppTheme.primaryColor,
          AppTheme.secondaryColor,
          AppTheme.accentColor,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: 30));

    canvas.drawCircle(center, 30, corePaint);

    // Inner sparkle
    final sparkePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, 8, sparkePaint);
  }

  void _drawSkillLabel(Canvas canvas, Offset position, String label, double orbSize) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: AppTheme.textPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          shadows: [
            Shadow(
              color: AppTheme.backgroundColor,
              blurRadius: 4,
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    
    final labelPosition = Offset(
      position.dx - textPainter.width / 2,
      position.dy - orbSize - textPainter.height - 10,
    );

    textPainter.paint(canvas, labelPosition);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}