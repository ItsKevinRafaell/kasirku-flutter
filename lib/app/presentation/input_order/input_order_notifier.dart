import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:kasirku_flutter/core/provider/app_provider.dart';

class InputOrderNotifier extends AppProvider {
  InputOrderNotifier() {
    init();
  }

  static const String NAME = 'NAME';
  static const String GENDER = 'GENDER';

  bool _isShowCustomer = true;
  HashMap<String, String> _errorCustomer = HashMap();

  final List<DropdownMenuEntry<String>> _genderListDropdown = [
    DropdownMenuEntry<String>(value: 'male', label: 'Laki-laki'),
    DropdownMenuEntry<String>(value: 'female', label: 'Perempuan'),
  ];

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _birthdayController = TextEditingController();
  TextEditingController _notesController = TextEditingController();

  bool get isShowCustomer => _isShowCustomer;
  HashMap<String, String> get errorCustomer => _errorCustomer;

  List<DropdownMenuEntry<String>> get genderListDropdown => _genderListDropdown;

  TextEditingController get nameController => _nameController;
  TextEditingController get phoneController => _phoneController;
  TextEditingController get emailController => _emailController;
  TextEditingController get genderController => _genderController;
  TextEditingController get birthdayController => _birthdayController;
  TextEditingController get notesController => _notesController;

  set isShowCustomer(bool param) => _isShowCustomer = param;

  @override
  init() {}

  validateCustomer() {
    showLoading();
    _errorCustomer.clear();
    if (_nameController.text.isEmpty) {
      _errorCustomer[NAME] = 'Nama harus diisi';
    }
    if (_genderController.text.isEmpty) {
      _errorCustomer[GENDER] = 'Jenis kelamin harus diisi';
    }
    hideLoading();
  }
}
