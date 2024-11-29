import 'package:kasirku_flutter/app/domain/entity/product.dart';
import 'package:kasirku_flutter/core/network/data_state.dart';

abstract class ProductRepository {
  Future<DataState<List<ProductEntity>>> getAll();
  Future<DataState<ProductEntity>> getByBarcode(String param);
}
