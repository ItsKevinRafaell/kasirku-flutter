import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kasirku_flutter/app/domain/entity/product.dart';
import 'package:kasirku_flutter/app/domain/usecase/product_get_all.dart';
import 'package:kasirku_flutter/core/provider/app_provider.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class AddProductOrderNotifier extends AppProvider {
  final ProductGetAllUseCase _productGetAllUseCase;
  final List<ProductItemOrderEntity> _listOrderOld;

  AddProductOrderNotifier(this._listOrderOld, this._productGetAllUseCase) {
    init();
  }

  TextEditingController _searchController = TextEditingController();

  TextEditingController get searchController => _searchController;

  List<ProductItemOrderEntity> _listOrderItem = [];

  List<ProductItemOrderEntity> get listOrderItem {
    if (_searchController.text.isEmpty)
      return _listOrderItem;
    else {
      return _listOrderItem
          .where((element) =>
              element.name
                  .toUpperCase()
                  .contains(_searchController.text.toUpperCase()) ||
              (element.barcode
                      ?.toUpperCase()
                      .contains(_searchController.text.toUpperCase()) ??
                  false))
          .toList();
    }
  }

  List<ProductItemOrderEntity> get listOrderItemFilteredQuantity {
    return _listOrderItem.where((item) => item.quantity > 0).toList();
  }

  int get totalProduct {
    int totalTemp = 0;
    _listOrderItem.forEach((element) => totalTemp += element.quantity);
    return totalTemp;
  }

  @override
  init() async {
    await _getProduct();
  }

  _getProduct() async {
    showLoading();
    final response = await _productGetAllUseCase();
    if (response.success) {
      final _listProductActive =
          response.data!.where((element) => element.isActive).toList();
      _listOrderItem =
          List<ProductItemOrderEntity>.from(_listProductActive.map((item) {
        final int index =
            _listOrderOld.indexWhere((element) => element.id == item.id);
        return ProductItemOrderEntity(
            id: item.id,
            name: item.name,
            quantity: (index > -1) ? _listOrderOld[index].quantity : 0,
            price: item.price,
            stock: item.stock,
            barcode: item.barcode);
      }));
    } else {
      errorMessage = response.message;
    }
    hideLoading();
  }

  updateQuantity(ProductItemOrderEntity item, int newQuantity) {
    final index = _listOrderItem.indexOf(item);
    if (newQuantity >= 0) {
      _listOrderItem[index] =
          _listOrderItem[index].copyWith(quantity: newQuantity);
    }
    notifyListeners();
  }

  submitSearch() {
    notifyListeners();
  }

  clearSearch() {
    _searchController.clear();
    notifyListeners();
  }

  scan() async {
    try {
      final barcodeText = await FlutterBarcodeScanner.scanBarcode(
          '#000000', 'Batal', true, ScanMode.BARCODE);
      if (barcodeText != '-1') {
        _searchController.text = barcodeText;
        _updateQuantityFromBarcode(barcodeText);
      } else {
        snackBarMessage = 'Scan barcode dibatalkan';
      }
    } on PlatformException {
      snackBarMessage = 'Error scan barcode';
    }

    notifyListeners();
  }

  _updateQuantityFromBarcode(String param) {
    final index =
        _listOrderItem.indexWhere((element) => element.barcode == param);
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
      snackBarMessage = 'Produk (#${param}) tidak ditemukan';
    }
    notifyListeners();
  }
}
