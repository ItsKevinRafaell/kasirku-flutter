import 'package:kasirku_flutter/app/domain/entity/order.dart';
import 'package:kasirku_flutter/app/domain/repository/order_repository.dart';
import 'package:kasirku_flutter/core/network/data_state.dart';
import 'package:kasirku_flutter/core/use_case/app_use_case.dart';

class OrderGetAllUseCase
    extends AppUseCase<Future<DataState<List<OrderEntity>>>, void> {
  final OrderRepository _orderRepository;

  OrderGetAllUseCase(this._orderRepository);

  @override
  Future<DataState<List<OrderEntity>>> call({void param}) {
    return _orderRepository.getAll();
  }
}
