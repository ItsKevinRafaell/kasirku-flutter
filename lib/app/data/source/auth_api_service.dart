import 'package:kasirku_flutter/core/constant/constant.dart';
import 'package:kasirku_flutter/core/network/data_state.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'auth_api_service.g.dart';

@RestApi()
abstract class AuthApiService {
  factory AuthApiService(Dio dio) {
    return _AuthApiService(dio);
  }

  @POST(AUTH_URL)
  Future<HttpResponse<DataState>> login(
      {@Body() required Map<String, dynamic> body});
}
