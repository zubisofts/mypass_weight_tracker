import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:mypass_weight_tracker/helpers/app_utils.dart';
import 'package:mypass_weight_tracker/repository/auth_repository.dart';
import 'package:mypass_weight_tracker/viewmodel/base_view_model.dart';

class AuthViewModel extends BaseViewModel {
  final AuthRepository _authRepository;
  User? _user;

  AuthViewModel(this._authRepository) {
    _authRepository.listenToAuthChange().listen((authUser) {
      _user = authUser;
      notifyListeners();
    });
  }

  User? get user => _user;

  bool get isSignedIn => _user != null;

  Future<void> signIn() async {
    setState = AppState.loading;
    var result = await _authRepository.signInUser();
    if (result.isLeft) {
      setState = AppState.error;
      AppUtils.makeToast("Login failed: ${result.left.errorMessage}");
    } else {
      setState = AppState.success;
      AppUtils.makeToast("Login successful");
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
  }
}
