import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/home_screen/home_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String homeScreen = '/home-screen';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.initial,
  routes: [
    GoRoute(
      path: AppRoutes.initial,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 280),
      ),
    ),
    GoRoute(
      path: AppRoutes.homeScreen,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 280),
      ),
    ),
  ],
);
