import 'package:flutter/material.dart';

abstract class AppProvider with ChangeNotifier {
  bool _isDispose = false;
  bool _isLoading = false;
  String _errorMessage = '';
  String _snackBarMessage = '';

  bool get isDispose => _isDispose;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get snackBarMessage => _snackBarMessage;

  set errorMessage(String message) => _errorMessage = message;
  set snackBarMessage(String message) => _snackBarMessage = message;

  showLoading() {
    if (!_isDispose) {
      _isLoading = true;
      notifyListeners();
    }
  }

  hideLoading() {
    if (!_isDispose) {
      _isLoading = false;
      notifyListeners();
    }
  }

  init();

  @override
  void dispose() {
    _isDispose = true;
    super.dispose();
  }
}
