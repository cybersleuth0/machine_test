import 'package:flutter/material.dart';
import '../../views/auth/LoginPage.dart';
import '../../views/auth/signUpPage.dart';
import '../../views/user_list/HomePage.dart';

class AppRoutes {
  static const String ROUTE_HOMEPAGE = "/homePage";
  static const String ROUTE_SIGNUPPAGE = "/signUpPage";
  static const String ROUTE_LOGINPAGE = "/logInPage";

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      ROUTE_HOMEPAGE: (context) => const HomePage(),
      ROUTE_SIGNUPPAGE: (context) => const SignUpPage(),
      ROUTE_LOGINPAGE: (context) => const LogInPage(),
    };
  }
}
