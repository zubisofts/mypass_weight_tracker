import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mypass_weight_tracker/di/injector.dart';
import 'package:mypass_weight_tracker/model/weight.dart';
import 'package:mypass_weight_tracker/repository/database_repository.dart';
import 'package:mypass_weight_tracker/viewmodel/auth_view_model.dart';
import 'package:mypass_weight_tracker/viewmodel/base_view_model.dart';

class DatabaseViewModel extends BaseViewModel {
  final DatabaseRepository _databaseRepository;

  StreamSubscription? _weightSubscription;

  List<Weight> _weights = [];

  List<Weight> get weights => _weights;

  DatabaseViewModel(this._databaseRepository) {
    loadWeights();
  }

  void loadWeights() {
    if (_weightSubscription != null) {
      _weightSubscription!.cancel();
    }
    _weightSubscription = _databaseRepository
        .getWeights(injector.get<AuthViewModel>().user!.uid)
        .listen((weights) {
      log('WEIGHT LENGTH: ${weights.length}');
      _updateWeightList(weights);
    });
  }

  Future<void> addWeight(Weight weight,
      {required VoidCallback onSuccess,
      required Function(String message) onFailure}) async {
    setState = AppState.loading;
    var result = await _databaseRepository.addWeight(
        weight.copyWith(userId: injector.get<AuthViewModel>().user!.uid));
    if (result.isLeft) {
      setState = AppState.error;
      onFailure(result.left.errorMessage);
    } else {
      setState = AppState.success;
      onSuccess();
    }
  }

  void _updateWeightList(List<Weight> weights) {
    _weights = weights;
    notifyListeners();
  }

  @override
  void dispose() {
    _weightSubscription!.cancel();
    super.dispose();
  }

  void deleteWeightItem(String id,
      {required VoidCallback onSuccess,
      required Function(String message) onFailure}) async {
    setState = AppState.loading;
    var result = await _databaseRepository.deleteWeight(id);
    if (result.isLeft) {
      setState = AppState.error;
      onFailure(result.left.errorMessage);
    } else {
      setState = AppState.success;
      onSuccess();
    }
  }

  void updateWeight(Weight weight,
      {required Function(String message) onFailure,
      required VoidCallback onSuccess}) async {
    setState = AppState.loading;
    var result = await _databaseRepository.updateWeight(
        weight.copyWith(userId: injector.get<AuthViewModel>().user!.uid));
    if (result.isLeft) {
      setState = AppState.error;
      onFailure(result.left.errorMessage);
    } else {
      setState = AppState.success;
      onSuccess();
    }
  }
}
