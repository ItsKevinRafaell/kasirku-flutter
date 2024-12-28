import 'package:kasirku_flutter/app/domain/entity/order.dart';
import 'package:kasirku_flutter/app/domain/repository/order_repository.dart';
import 'package:kasirku_flutter/core/network/data_state.dart';
import 'package:kasirku_flutter/core/use_case/app_use_case.dart';

class OrderGetByIdUseCase
    extends AppUseCase<Future<DataState<OrderEntity>>, int> {
  final OrderRepository _orderRepository;

  OrderGetByIdUseCase(this._orderRepository);

  @override
  Future<DataState<OrderEntity>> call({int? param}) async {
    return _orderRepository.getById(param!);
  }
}
