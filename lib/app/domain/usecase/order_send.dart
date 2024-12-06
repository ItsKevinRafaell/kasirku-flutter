import 'package:kasirku_flutter/app/domain/entity/order.dart';
import 'package:kasirku_flutter/app/domain/repository/order_repository.dart';
import 'package:kasirku_flutter/core/network/data_state.dart';
import 'package:kasirku_flutter/core/use_case/app_use_case.dart';

class OrderSendUseCase extends AppUseCase<Future<DataState>, OrderEntity> {
  final OrderRepository _orderRepository;

  OrderSendUseCase(this._orderRepository);
  @override
  Future<DataState> call({OrderEntity? param}) {
    throw UnimplementedError();
  }
}
