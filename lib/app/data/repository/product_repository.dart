import 'package:kasirku_flutter/app/data/source/product_api_service.dart';
import 'package:kasirku_flutter/app/domain/entity/product.dart';
import 'package:kasirku_flutter/app/domain/repository/product_repository.dart';
import 'package:kasirku_flutter/core/network/data_state.dart';

class ProductRepositoryImpl extends ProductRepository {
  final ProductApiService _productApiService;

  ProductRepositoryImpl(this._productApiService);

  @override
  Future<DataState<List<ProductEntity>>> getAll() {
    return handleResponse(
        () => _productApiService.getAll(),
        (json) => List<ProductEntity>.from(
            json.map((item) => ProductEntity.fromJson(item))));
  }

  @override
  Future<DataState<ProductEntity>> getByBarcode(String param) {
    return handleResponse(() => _productApiService.getByBarcode(barcode: param),
        (json) => ProductEntity.fromJson(json));
  }
}
