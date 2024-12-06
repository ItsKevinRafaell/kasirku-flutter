import 'package:kasirku_flutter/core/constant/constant.dart';
import 'package:kasirku_flutter/core/helper/shared_preferences_helper.dart';
import 'package:kasirku_flutter/core/provider/app_provider.dart';

class ProfilNotifier extends AppProvider {
  ProfilNotifier() {
    init();
  }

  bool _isLogout = false;
  bool get isLogout => _isLogout;

  String _name = '';
  String get name => _name;

  String _email = '';
  String get email => _email;

  @override
  init() async {
    await _getDetailUser();
  }

  _getDetailUser() async {
    showLoading();
    _name = await SharedPreferencesHelper.getString(PREF_NAME);
    _email = await SharedPreferencesHelper.getString(PREF_EMAIL);
    hideLoading();
  }

  logout() async {
    showLoading();
    await SharedPreferencesHelper.logout();
    _isLogout = true;
    hideLoading();
  }
}
