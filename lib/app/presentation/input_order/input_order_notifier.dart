import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kasirku_flutter/app/domain/entity/product.dart';
import 'package:kasirku_flutter/app/domain/usecase/product_get_by_barcode.dart';
import 'package:kasirku_flutter/core/provider/app_provider.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class InputOrderNotifier extends AppProvider {
  final ProductGetByBarcodeUseCase _productGetByBarcodeUseCase;
  InputOrderNotifier(this._productGetByBarcodeUseCase) {
    init();
  }

  static const String NAME = 'NAME';
  static const String GENDER = 'GENDER';

  bool _isShowCustomer = true;
  HashMap<String, String> _errorCustomer = HashMap();
  List<ProductItemOrderEntity> _listOrderItem = [];

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
  List<ProductItemOrderEntity> get listOrderItem => _listOrderItem;
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

  updateItems(List<ProductItemOrderEntity> items) {
    _listOrderItem.clear();
    _listOrderItem.addAll(items);
    notifyListeners();
  }

  updateQuantity(ProductItemOrderEntity item, int newQuantity) {
    final index = _listOrderItem.indexOf(item);
    if (newQuantity == 0) {
      _listOrderItem.removeAt(index);
    } else {
      _listOrderItem[index] =
          _listOrderItem[index].copyWith(quantity: newQuantity);
    }
    notifyListeners();
  }

  scan() async {
    try {
      final barcodeText = await FlutterBarcodeScanner.scanBarcode(
          '#000000', 'Batal', true, ScanMode.BARCODE);
      if (barcodeText != '-1') {
        _getProductByBarcode(barcodeText);
      } else {
        snackBarMessage = 'Scan barcode dibatalkan';
      }
    } on PlatformException {
      snackBarMessage = 'Error scan barcode';
    }

    notifyListeners();
  }

  _getProductByBarcode(String param) async {
    showLoading();
    final response = await _productGetByBarcodeUseCase.call(param: param);
    if (response.success) {
      final product = response.data!;
      final index =
          _listOrderItem.indexWhere((element) => element.id == product.id);
      if (index >= 0) {
        final item = _listOrderItem[index];
        if (item.stock != null &&
            item.stock! > 0 &&
            item.stock! > item.quantity) {
          _listOrderItem[index] = item.copyWith(quantity: item.quantity + 1);
        } else {
          snackBarMessage =
              'Stok produk ${item.name} (#${item.barcode}) sudah habis';
        }
      } else {
        if (product.stock > 0) {
          _listOrderItem.add(ProductItemOrderEntity(
              id: product.id,
              name: product.name,
              quantity: 1,
              price: product.price,
              barcode: product.barcode,
              stock: product.stock));
        } else {
          snackBarMessage =
              'Stok produk ${product.name} (#${product.barcode}) kosong';
        }
      }
    } else {
      snackBarMessage = response.message;
    }
    hideLoading();
  }
}
