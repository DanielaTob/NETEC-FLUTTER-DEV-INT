import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:auth_firebase_app/providers/auth_providers.dart';
import 'package:auth_firebase_app/screens/home_screen.dart';
import 'package:auth_firebase_app/screens/login_screen.dart';
import 'package:auth_firebase_app/screens/register_screen.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      redirect: (_, state) {
        final container = ProviderContainer();
        final authState = container.read(authStateProvider);
        return authState == null ? '/login' : null;
      },
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => RegisterScreen(),
    ),
  ],
);