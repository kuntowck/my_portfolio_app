import 'package:flutter/material.dart';
import 'package:my_portfolio_app/screens/contact_screen.dart';
import 'package:my_portfolio_app/screens/not_found_screen.dart';
import 'package:my_portfolio_app/screens/portfolio_form_screen.dart';
import 'package:my_portfolio_app/screens/portfolio_screen.dart';
import 'package:my_portfolio_app/screens/profile_edit_screen.dart';
import 'package:my_portfolio_app/screens/profile_screen.dart';
import 'package:my_portfolio_app/screens/settings_screen.dart';

class AppRoutes {
  static const profile = '/profile';
  static const editProfile = '/editProfile';
  static const portfolio = '/portfolio';
  static const addPortfolio = '/addPortfolio';
  static const contact = '/contact';
  static const setting = '/settings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
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
