import 'package:flutter/material.dart';
import 'package:kasirku_flutter/app/domain/entity/order.dart';
import 'package:kasirku_flutter/app/domain/usecase/payment_method_get_all.dart';
import 'package:kasirku_flutter/core/provider/app_provider.dart';

class CheckoutNotifier extends AppProvider {
  final OrderEntity _order;
  final PaymentMethodGetAllUseCase _paymentMethodGetAllUseCase;

  CheckoutNotifier(this._order, this._paymentMethodGetAllUseCase) {
    init();
  }

  static const String MALE = 'male';
  static const String FEMALE = 'female';

  List<DropdownMenuEntry<int>> _listDropdownPaymentMethod = [];
  int _selectedPaymentMethod = -1;

  TextEditingController _totalController = TextEditingController();
  TextEditingController _methodController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _changeController = TextEditingController();

  TextEditingController get totalController => _totalController;
  TextEditingController get methodController => _methodController;
  TextEditingController get amountController => _amountController;
  TextEditingController get changeController => _changeController;

  int get selectedPaymentMethod => _selectedPaymentMethod;

  List<DropdownMenuEntry<int>> get listDropdownPaymentMethod =>
      _listDropdownPaymentMethod;

  OrderEntity get order => _order;
  @override
  init() {
    _getPaymentMethod();
  }

  _getPaymentMethod() async {
    showLoading();
    final response = await _paymentMethodGetAllUseCase();
    if (response.success) {
      _listDropdownPaymentMethod = List<DropdownMenuEntry<int>>.from(response
          .data!
          .map((e) => DropdownMenuEntry<int>(value: e.id, label: e.name)));
      _selectedPaymentMethod = response.data!.first.id;
      hideLoading();
    }
  }

  send() async {
    showLoading();
  }
}
