import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:kasirku_flutter/app/presentation/add_product_order/add_product_order_notifier.dart';
import 'package:kasirku_flutter/app/presentation/checkout/checkout_notifier.dart';
import 'package:kasirku_flutter/app/presentation/home/home_notifier.dart';
import 'package:kasirku_flutter/app/presentation/input_order/input_order_notifier.dart';
import 'package:kasirku_flutter/app/presentation/login/login_notifier.dart';
import 'package:kasirku_flutter/app/presentation/order/order_notifier.dart';
import 'package:kasirku_flutter/app/presentation/print/print_notifier.dart';
import 'package:kasirku_flutter/core/network/app_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final sl = GetIt.instance;

void initDependency() {
  Dio dio = Dio();
  dio.interceptors.add(PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    responseHeader: false,
    compact: false,
  ));
  dio.interceptors.add(AppInterceptor());

  sl.registerSingleton<Dio>(dio);

  sl.registerFactoryParam<LoginNotifier, void, void>(
      (param1, param2) => LoginNotifier());

  sl.registerFactoryParam<HomeNotifier, void, void>(
      (param1, param2) => HomeNotifier());

  sl.registerFactoryParam<OrderNotifier, void, void>(
      (param1, param2) => OrderNotifier());

  sl.registerFactoryParam<InputOrderNotifier, void, void>(
      (param1, param2) => InputOrderNotifier());

  sl.registerFactoryParam<AddProductOrderNotifier, void, void>(
      (param1, param2) => AddProductOrderNotifier());

  sl.registerFactoryParam<CheckoutNotifier, void, void>(
      (param1, param2) => CheckoutNotifier());

  sl.registerFactoryParam<PrintNotifier, void, void>(
      (param1, param2) => PrintNotifier());
}
