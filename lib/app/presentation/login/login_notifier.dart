import 'package:flutter/material.dart';
import 'package:kasirku_flutter/core/constant/constant.dart';
import 'package:kasirku_flutter/core/helper/shared_preferences_helper.dart';
import 'package:kasirku_flutter/core/provider/app_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginNotifier extends AppProvider {
  LoginNotifier() {
    init();
  }

  TextEditingController _baseUrlController = TextEditingController();

  TextEditingController get baseUrlController => _baseUrlController;

  @override
  init() async {
    await _getBaseUrl();
  }

  _getBaseUrl() async {
    final baseUrlPref = await SharedPreferencesHelper.getString(PREF_BASE_URL);
    if (baseUrlPref == null) {
      _baseUrlController.text = 'https://kasir.dewakoding.com';
      await SharedPreferencesHelper.setString(
          PREF_BASE_URL, _baseUrlController.text);
    } else {
      _baseUrlController.text = baseUrlPref;
    }

    hideLoading();
  }

  saveBaseUrl() {
    SharedPreferencesHelper.setString(PREF_BASE_URL, _baseUrlController.text);
  }
}
