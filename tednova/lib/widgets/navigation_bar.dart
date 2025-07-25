import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_theme.dart';

class TeddyNovaNavigationBar extends StatefulWidget {
  const TeddyNovaNavigationBar({super.key});

  @override
  State<TeddyNovaNavigationBar> createState() => _TeddyNovaNavigationBarState();
}

class _TeddyNovaNavigationBarState extends State<TeddyNovaNavigationBar> {
  String _hoveredItem = '';

  final List<NavItem> _navItems = [
    NavItem('Home', '/', Icons.home),
    NavItem('About', '/about', Icons.person),
    NavItem('Projects', '/projects', Icons.rocket_launch),
    NavItem('Blog', '/blog', Icons.article),
    NavItem('Contact', '/contact', Icons.contact_mail),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.backgroundColor.withOpacity(0.9),
            AppTheme.surfaceColor.withOpacity(0.8),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: AppTheme.primaryColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Logo
          _buildLogo(),
          
          const Spacer(),
          
          // Navigation items
          if (!isMobile) ..._buildDesktopNav(),
          
          // Mobile menu button
          if (isMobile) _buildMobileMenuButton(),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.auto_awesome,
            color: Colors.black,
            size: 24,
          ),
        ).animate().scale(delay: 300.ms),
        
        const SizedBox(width: 12),
        
        Text(
          'TeddyNova',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..shader = AppTheme.primaryGradient.createShader(
                const Rect.fromLTWH(0, 0, 200, 70),
              ),
          ),
        ).animate().slideX(delay: 500.ms),
      ],
    );
  }

  List<Widget> _buildDesktopNav() {
    return _navItems.map((item) {
      final isHovered = _hoveredItem == item.label;
      
      return MouseRegion(
        onEnter: (_) => setState(() => _hoveredItem = item.label),
        onExit: (_) => setState(() => _hoveredItem = ''),
        child: GestureDetector(
          onTap: () => context.go(item.route),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isHovered 
                    ? AppTheme.primaryColor 
                    : Colors.transparent,
                width: 1,
              ),
              gradient: isHovered
                  ? LinearGradient(
                      colors: [
                        AppTheme.primaryColor.withOpacity(0.1),
                        AppTheme.secondaryColor.withOpacity(0.1),
                      ],
                    )
                  : null,
              boxShadow: isHovered
                  ? [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  color: isHovered 
                      ? AppTheme.primaryColor 
                      : AppTheme.textSecondary,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  item.label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: isHovered 
                        ? AppTheme.primaryColor 
                        : AppTheme.textSecondary,
                    fontWeight: isHovered 
                        ? FontWeight.w600 
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ).animate().fadeIn(delay: (800 + _navItems.indexOf(item) * 100).ms);
    }).toList();
  }

  Widget _buildMobileMenuButton() {
    return IconButton(
      onPressed: () {
        // TODO: Implement mobile menu
        _showMobileMenu(context);
      },
      icon: const Icon(
        Icons.menu,
        color: AppTheme.primaryColor,
      ),
    ).animate().scale(delay: 800.ms);
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _navItems
              .map((item) => ListTile(
                    leading: Icon(item.icon, color: AppTheme.primaryColor),
                    title: Text(
                      item.label,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      context.go(item.route);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class NavItem {
  final String label;
  final String route;
  final IconData icon;

  NavItem(this.label, this.route, this.icon);
}