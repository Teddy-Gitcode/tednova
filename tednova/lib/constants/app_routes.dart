import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/about_screen.dart';
import '../screens/projects_screen.dart';
import '../screens/blog_screen.dart';
import '../screens/contact_screen.dart';
import '../screens/admin_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String about = '/about';
  static const String projects = '/projects';
  static const String blog = '/blog';
  static const String contact = '/contact';
  static const String admin = '/admin';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    routes: [
      GoRoute(
        path: home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: about,
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: projects,
        builder: (context, state) => const ProjectsScreen(),
      ),
      GoRoute(
        path: blog,
        builder: (context, state) => const BlogScreen(),
      ),
      GoRoute(
        path: contact,
        builder: (context, state) => const ContactScreen(),
      ),
      GoRoute(
        path: admin,
        builder: (context, state) => const AdminScreen(),
      ),
    ],
  );
}