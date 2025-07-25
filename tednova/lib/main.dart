import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants/app_theme.dart';
import 'constants/app_routes.dart';
import 'providers/app_provider.dart';
import 'screens/home_screen.dart';
import 'screens/about_screen.dart';
import 'screens/projects_screen.dart';
import 'screens/blog_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/admin_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase (for web, this will be handled by firebase-config.js)
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "your-api-key",
        authDomain: "tednova-portfolio.firebaseapp.com",
        projectId: "tednova-portfolio",
        storageBucket: "tednova-portfolio.appspot.com",
        messagingSenderId: "123456789",
        appId: "your-app-id",
      ),
    );
  } catch (e) {
    print('Firebase initialization error: $e');
  }
  
  runApp(const TeddyNovaApp());
}

class TeddyNovaApp extends StatelessWidget {
  const TeddyNovaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: MaterialApp.router(
        title: 'TeddyNova - Futuristic Portfolio',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        routerConfig: AppRoutes.router,
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        ),
      ),
    );
  }
}
