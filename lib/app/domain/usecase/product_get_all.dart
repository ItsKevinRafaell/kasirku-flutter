import 'package:kasirku_flutter/app/domain/entity/product.dart';
import 'package:kasirku_flutter/app/domain/repository/product_repository.dart';
import 'package:kasirku_flutter/core/network/data_state.dart';
import 'package:kasirku_flutter/core/use_case/app_use_case.dart';

class ProductGetAllUseCase
    extends AppUseCase<Future<DataState<List<ProductEntity>>>, void> {
  final ProductRepository _productRepository;

  ProductGetAllUseCase(this._productRepository);

  @override
  Future<DataState<List<ProductEntity>>> call({void param}) {
    return _productRepository.getAll();
  }
}
