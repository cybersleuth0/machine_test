import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:machine_test/core/services/shared_preferences_service.dart';

import '../data/repositories/auth_repository.dart';

class AuthViewmodel extends ChangeNotifier {
  final AuthRepository _authRepository;
  AuthViewmodel(this._authRepository) {
    checkAuthStatus();
  }

  //State Variables
  bool _isLoading = false;
  String? _errorMessage;
  User? _user;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get user => _user;
  //Helper Method
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  Future<void> checkAuthStatus() async {
    _setLoading(true);
    final bool loggedIn = await SharedPreferencesService.isLoggedIn();
    if (loggedIn) {
      _user = _authRepository.getUser();
    } else {
      _user = null;
    }
    _setLoading(false);
  }

  //Login
  Future<bool> login({required String email, required String password}) async {
    _setLoading(true);
    _clearError();
    try {
      _user = await _authRepository.login(email: email, password: password);
      await SharedPreferencesService.setLoggedIn(true);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  //Sign Up
  Future<bool> signUp({required String email, required String password}) async {
    _setLoading(true);
    _clearError();

    try {
      _user = await _authRepository.signUp(email, password);
      await SharedPreferencesService.setLoggedIn(true);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  //Logout
  Future<void> logOut() async {
    _setLoading(true);
    try {
      await _authRepository.signOut();
      await SharedPreferencesService.clearSession();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }
}
