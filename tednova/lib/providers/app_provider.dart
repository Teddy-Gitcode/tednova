import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  bool _isLoading = false;
  String _currentSection = 'home';
  bool _showParticles = true;
  double _scrollOffset = 0.0;

  // Getters
  bool get isLoading => _isLoading;
  String get currentSection => _currentSection;
  bool get showParticles => _showParticles;
  double get scrollOffset => _scrollOffset;

  // Loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Current section
  void setCurrentSection(String section) {
    _currentSection = section;
    notifyListeners();
  }

  // Particle animation toggle
  void toggleParticles() {
    _showParticles = !_showParticles;
    notifyListeners();
  }

  // Scroll offset for parallax effects
  void updateScrollOffset(double offset) {
    _scrollOffset = offset;
    notifyListeners();
  }

  // Navigation helper
  void navigateToSection(String section) {
    setCurrentSection(section);
  }
}