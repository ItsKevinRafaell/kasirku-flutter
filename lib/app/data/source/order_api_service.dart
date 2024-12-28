import 'package:dio/dio.dart';
import 'package:kasirku_flutter/core/constant/constant.dart';
import 'package:kasirku_flutter/core/network/data_state.dart';
import 'package:retrofit/retrofit.dart';

part 'order_api_service.g.dart';

@RestApi()
abstract class OrderApiService {
  factory OrderApiService(Dio dio) {
    return _OrderApiService(dio);
  }

  @GET(ORDER_URL)
  Future<HttpResponse<DataState>> getAll();

  @GET('$ORDER_URL/{id}')
  Future<HttpResponse<DataState>> getById({@Path('id') required int id});

  @POST(ORDER_URL)
  Future<HttpResponse<DataState>> insert(
      {@Body() required Map<String, dynamic> body});

  @PUT('$ORDER_URL/{id}')
  Future<HttpResponse<DataState>> update(
      {@Path('id') required int id,
      @Body() required Map<String, dynamic> body});
}
