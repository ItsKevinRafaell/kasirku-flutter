import 'package:kasirku_flutter/app/domain/entity/product.dart';
import 'package:kasirku_flutter/app/domain/repository/product_repository.dart';
import 'package:kasirku_flutter/core/network/data_state.dart';
import 'package:kasirku_flutter/core/use_case/app_use_case.dart';

class ProductGetByBarcodeUseCase
    extends AppUseCase<Future<DataState<ProductEntity>>, String> {
  final ProductRepository _repository;

  ProductGetByBarcodeUseCase(this._repository);

  @override
  Future<DataState<ProductEntity>> call({String? param}) async {
    return await _repository.getByBarcode(param ?? '');
  }
}
