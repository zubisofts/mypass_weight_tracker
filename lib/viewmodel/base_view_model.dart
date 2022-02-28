import 'package:flutter/material.dart';

enum AppState {
  initial,
  loading,
  error,
  success,
}

class BaseViewModel extends ChangeNotifier {
  AppState _state = AppState.initial;

  AppState get state => _state;

  set setState(AppState status) {
    _state = status;
    notifyListeners();
  }
}
