import 'package:flutter/foundation.dart';

import '../data/models/userModel.dart';
import '../data/repositories/user_repository.dart';

class UserViewmodel extends ChangeNotifier {
  final UserRepository _userRepository;

  UserViewmodel(this._userRepository) {
    fetchInitialUsers();
  }
  // --- State Variables ---
  List<UserDataModel> _users = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _errorMessage;
  int _currentPage = 1;
  int _totalPages = 1;
  static const int _perPage = 5;

  // --- Getters ---
  List<UserDataModel> get users => _users;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _currentPage < _totalPages;

  Future<void> fetchInitialUsers() async {
    _isLoading = true;
    _errorMessage = null;
    _currentPage = 1;
    notifyListeners();
    try {
      final userData = await _userRepository.fetchUsers(page: _currentPage, perPage: _perPage);
      _users = userData.userDataModel;
      _totalPages = userData.totalPages;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreUsers() async {
    if (_isLoadingMore || !hasMore || _isLoading) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final userData = await _userRepository.fetchUsers(page: nextPage, perPage: _perPage);
      _users.addAll(userData.userDataModel);
      _currentPage = nextPage;
      _totalPages = userData.totalPages;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> refreshUsers() async {
    await fetchInitialUsers();
  }
}
