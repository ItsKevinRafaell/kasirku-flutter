import 'package:kasirku_flutter/app/domain/entity/payment_method.dart';
import 'package:kasirku_flutter/core/network/data_state.dart';

abstract class PaymentMethodRepository {
  Future<DataState<List<PaymentMethodEntity>>> getAll();
}
