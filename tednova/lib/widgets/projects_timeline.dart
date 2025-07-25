import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../constants/app_theme.dart';

class ProjectsTimeline extends StatelessWidget {
  const ProjectsTimeline({super.key});

  final List<Project> _projects = const [
    Project(
      title: 'Plant Disease Detection AI',
      description: 'Machine learning model using TensorFlow to identify plant diseases from leaf images with 95% accuracy.',
      technologies: ['TensorFlow', 'Python', 'Computer Vision', 'Agriculture'],
      year: '2024',
      status: 'Completed',
    ),
    Project(
      title: 'Smart Farming IoT System',
      description: 'IoT-based monitoring system for soil moisture, temperature, and crop health using Arduino and sensors.',
      technologies: ['IoT', 'Arduino', 'Firebase', 'Flutter'],
      year: '2023',
      status: 'Ongoing',
    ),
    Project(
      title: 'Agricultural Drone Platform',
      description: 'Autonomous drone system for crop monitoring and precision agriculture applications.',
      technologies: ['Drones', 'Computer Vision', 'GPS', 'Machine Learning'],
      year: '2023',
      status: 'Research',
    ),
    Project(
      title: 'Space Debris Tracking',
      description: 'Satellite tracking system for monitoring space debris and collision prediction.',
      technologies: ['Python', 'Orbital Mechanics', 'Data Analysis'],
      year: '2022',
      status: 'Completed',
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
            'Projects Timeline',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontSize: isMobile ? 28 : 36,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn().slideY(begin: -0.3),

          const SizedBox(height: 16),

          Text(
            'Journey through my innovation milestones',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 200.ms),

          const SizedBox(height: 60),

          // Timeline
          _buildTimeline(isMobile),
        ],
      ),
    );
  }

  Widget _buildTimeline(bool isMobile) {
    return Column(
      children: _projects.asMap().entries.map((entry) {
        final index = entry.key;
        final project = entry.value;
        final isLeft = index % 2 == 0;

        return _buildTimelineItem(project, isLeft, isMobile, index);
      }).toList(),
    );
  }

  Widget _buildTimelineItem(Project project, bool isLeft, bool isMobile, int index) {
    final card = _buildProjectCard(project, index);

    if (isMobile) {
      return Container(
        margin: const EdgeInsets.only(bottom: 40),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline indicator
            Column(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: _getStatusColor(project.status),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.primaryColor, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: _getStatusColor(project.status).withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
                if (index < _projects.length - 1)
                  Container(
                    width: 2,
                    height: 60,
                    color: AppTheme.primaryColor.withOpacity(0.3),
                  ),
              ],
            ),
            const SizedBox(width: 20),
            // Project card
            Expanded(child: card),
          ],
        ),
      ).animate().slideX(delay: (index * 200).ms, begin: 0.3);
    }

    // Desktop layout
    return Container(
      margin: const EdgeInsets.only(bottom: 60),
      child: Row(
        children: [
          // Left side
          Expanded(
            child: isLeft ? card : const SizedBox(),
          ),
          
          // Timeline center
          Column(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: _getStatusColor(project.status),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.primaryColor, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: _getStatusColor(project.status).withOpacity(0.5),
                      blurRadius: 15,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    project.year.substring(2),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
              if (index < _projects.length - 1)
                Container(
                  width: 3,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppTheme.primaryColor.withOpacity(0.5),
                        AppTheme.primaryColor.withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          
          // Right side
          Expanded(
            child: !isLeft ? card : const SizedBox(),
          ),
        ],
      ),
    ).animate().slideX(
      delay: (index * 300).ms,
      begin: isLeft ? -0.3 : 0.3,
    );
  }

  Widget _buildProjectCard(Project project, int index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project header
            Row(
              children: [
                Expanded(
                  child: Text(
                    project.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                _buildStatusBadge(project.status),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Description
            Text(
              project.description,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Technologies
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: project.technologies.map((tech) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    tech,
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(status),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppTheme.successColor;
      case 'ongoing':
        return AppTheme.warningColor;
      case 'research':
        return AppTheme.accentColor;
      default:
        return AppTheme.textSecondary;
    }
  }
}

class Project {
  final String title;
  final String description;
  final List<String> technologies;
  final String year;
  final String status;

  const Project({
    required this.title,
    required this.description,
    required this.technologies,
    required this.year,
    required this.status,
  });
}