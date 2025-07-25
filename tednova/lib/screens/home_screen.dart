import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_theme.dart';
import '../providers/app_provider.dart';
import '../widgets/cosmic_background.dart';
import '../widgets/navigation_bar.dart';
import '../widgets/hero_section.dart';
import '../widgets/skill_galaxy.dart';
import '../widgets/projects_timeline.dart';
import '../widgets/blog_mosaic.dart';
import '../widgets/contact_nebula.dart';
import '../widgets/constellation_footer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _heroAnimationController;
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _heroAnimationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _particleController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    // Start animations
    _heroAnimationController.forward();
    _particleController.repeat();

    // Listen to scroll for parallax effects
    _scrollController.addListener(() {
      context.read<AppProvider>().updateScrollOffset(_scrollController.offset);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _heroAnimationController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    
    return Scaffold(
      body: Stack(
        children: [
          // Cosmic background with particles
          const CosmicBackground(),
          
          // Main content
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Navigation Bar
              SliverAppBar(
                expandedHeight: 80,
                floating: true,
                pinned: true,
                backgroundColor: Colors.transparent,
                flexibleSpace: const TeddyNovaNavigationBar(),
              ),
              
              // Hero Section
              SliverToBoxAdapter(
                child: HeroSection(
                  animationController: _heroAnimationController,
                ),
              ),
              
              // Skill Galaxy Section
              const SliverToBoxAdapter(
                child: SkillGalaxy(),
              ),
              
              // Projects Timeline
              const SliverToBoxAdapter(
                child: ProjectsTimeline(),
              ),
              
              // Blog Mosaic
              const SliverToBoxAdapter(
                child: BlogMosaic(),
              ),
              
              // Contact Nebula
              const SliverToBoxAdapter(
                child: ContactNebula(),
              ),
              
              // Constellation Footer
              const SliverToBoxAdapter(
                child: ConstellationFooter(),
              ),
            ],
          ),
          
          // Floating action button for admin access
          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton(
              onPressed: () => context.go('/admin'),
              backgroundColor: AppTheme.primaryColor,
              child: const Icon(Icons.admin_panel_settings, color: Colors.black),
            ).animate().scale(delay: 2.seconds),
          ),
        ],
      ),
    );
  }
}