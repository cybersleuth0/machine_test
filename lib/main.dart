import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:machine_test/core/services/firebase_auth_service.dart';
import 'package:machine_test/core/services/shared_preferences_service.dart';
import 'package:machine_test/data/repositories/auth_repository.dart';
import 'package:machine_test/viewmodels/auth_viewmodel.dart';
import 'package:machine_test/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';

import 'core/constants/AppRoutes.dart';
import 'core/network/api_helper.dart';
import 'data/repositories/user_repository.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final bool isLoggedIn = await SharedPreferencesService.isLoggedIn();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthViewmodel(AuthRepository(firebaseAuthService: FirebaseAuthService())),
        ),
        ChangeNotifierProvider(create: (context) => UserViewmodel(UserRepository(apiHelper: ApiHelper()))),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: isLoggedIn ? AppRoutes.ROUTE_HOMEPAGE : AppRoutes.ROUTE_LOGINPAGE,
        routes: AppRoutes.getRoutes(),
      ),
    ),
  );
}
