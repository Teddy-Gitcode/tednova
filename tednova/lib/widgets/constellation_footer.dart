import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_theme.dart';

class ConstellationFooter extends StatelessWidget {
  const ConstellationFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 48,
        vertical: 60,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.backgroundColor,
            AppTheme.surfaceColor.withOpacity(0.5),
          ],
        ),
        border: const Border(
          top: BorderSide(
            color: AppTheme.primaryColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Social constellation
          _buildSocialConstellation(),
          
          const SizedBox(height: 40),
          
          // Footer links
          if (!isMobile) _buildFooterLinks() else _buildMobileFooterLinks(),
          
          const SizedBox(height: 30),
          
          // Copyright
          _buildCopyright(),
        ],
      ),
    );
  }

  Widget _buildSocialConstellation() {
    final socialLinks = [
      SocialLink('GitHub', Icons.code, 'https://github.com'),
      SocialLink('LinkedIn', Icons.work, 'https://linkedin.com'),
      SocialLink('Twitter', Icons.alternate_email, 'https://twitter.com'),
      SocialLink('Email', Icons.email, 'mailto:contact@tednova.com'),
    ];

    return Wrap(
      spacing: 20,
      runSpacing: 20,
      alignment: WrapAlignment.center,
      children: socialLinks.map((social) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => _launchUrl(social.url),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppTheme.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                social.icon,
                color: Colors.black,
                size: 24,
              ),
            ),
          ),
        ).animate().scale(delay: (socialLinks.indexOf(social) * 100).ms);
      }).toList(),
    );
  }

  Widget _buildFooterLinks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildFooterSection('Explore', [
          'Home',
          'About',
          'Projects',
          'Blog',
        ]),
        _buildFooterSection('Technologies', [
          'Flutter',
          'AI/ML',
          'Agriculture',
          'Space Tech',
        ]),
        _buildFooterSection('Connect', [
          'Contact',
          'Collaboration',
          'Research',
          'Innovation',
        ]),
      ],
    );
  }

  Widget _buildMobileFooterLinks() {
    return Column(
      children: [
        _buildFooterSection('Quick Links', [
          'Home',
          'About',
          'Projects',
          'Blog',
          'Contact',
        ]),
      ],
    );
  }

  Widget _buildFooterSection(String title, List<String> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...links.map((link) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            link,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
            ),
          ),
        )),
      ],
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildCopyright() {
    return Column(
      children: [
        const Divider(
          color: AppTheme.primaryColor,
          thickness: 0.5,
        ),
        const SizedBox(height: 20),
        Text(
          '© 2024 TeddyNova. Crafted with 💙 for the future.',
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Exploring the cosmos of technology, one innovation at a time.',
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 10,
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ).animate().fadeIn(delay: 600.ms);
  }

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class SocialLink {
  final String name;
  final IconData icon;
  final String url;

  SocialLink(this.name, this.icon, this.url);
}