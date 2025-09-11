import 'package:flutter/material.dart';
import 'package:my_portfolio_app/main.dart';
import 'package:my_portfolio_app/screens/admin/dashboard_screen.dart';
import 'package:my_portfolio_app/screens/contact_screen.dart';
import 'package:my_portfolio_app/screens/login_screen.dart';
import 'package:my_portfolio_app/screens/not_found_screen.dart';
import 'package:my_portfolio_app/screens/portfolio_form_screen.dart';
import 'package:my_portfolio_app/screens/portfolio_screen.dart';
import 'package:my_portfolio_app/screens/profile_edit_screen.dart';
import 'package:my_portfolio_app/screens/profile_screen.dart';
import 'package:my_portfolio_app/screens/register_screen.dart';
import 'package:my_portfolio_app/screens/settings_screen.dart';

class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const profile = '/profile';
  static const editProfile = '/editProfile';
  static const portfolio = '/portfolio';
  static const addPortfolio = '/addPortfolio';
  static const contact = '/contact';
  static const setting = '/settings';
  static const adminDashboard = '/adminDashboards';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case adminDashboard:
        return MaterialPageRoute(builder: (_) => AdminDashboardScreen());
      case home:
        return MaterialPageRoute(builder: (_) => MainScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      case editProfile:
        return MaterialPageRoute(builder: (_) => EditProfileScreen());
      case portfolio:
        return MaterialPageRoute(builder: (_) => PortfolioScreen());
      case addPortfolio:
        return MaterialPageRoute(builder: (_) => PortfolioFormScreen());
      case contact:
        return MaterialPageRoute(builder: (_) => ContactScreen());
      case setting:
        return MaterialPageRoute(builder: (_) => SettingsScreen());
      default:
        return MaterialPageRoute(builder: (_) => NotFoundScreen());
    }
  }
}
