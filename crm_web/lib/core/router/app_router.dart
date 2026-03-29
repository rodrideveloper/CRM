import 'package:flutter/material.dart';

import '../../pages/landing_page.dart';
import '../../pages/auth_page.dart';

class AppRouter {
  static const landing = '/';
  static const login = '/login';
  static const register = '/register';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return _fade(const AuthPage(isLogin: true));
      case register:
        return _fade(const AuthPage(isLogin: false));
      case landing:
      default:
        return _fade(const LandingPage());
    }
  }

  static PageRouteBuilder _fade(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
