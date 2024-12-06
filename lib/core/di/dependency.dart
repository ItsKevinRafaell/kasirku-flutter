import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:kasirku_flutter/app/data/repository/auth_repository.dart';
import 'package:kasirku_flutter/app/data/repository/order_repository.dart';
import 'package:kasirku_flutter/app/data/repository/product_repository.dart';
import 'package:kasirku_flutter/app/data/source/auth_api_service.dart';
import 'package:kasirku_flutter/app/data/source/order_api_service.dart';
import 'package:kasirku_flutter/app/data/source/product_api_service.dart';
import 'package:kasirku_flutter/app/domain/entity/product.dart';
import 'package:kasirku_flutter/app/domain/repository/auth_repository.dart';
import 'package:kasirku_flutter/app/domain/repository/order_repository.dart';
import 'package:kasirku_flutter/app/domain/repository/product_repository.dart';
import 'package:kasirku_flutter/app/domain/usecase/auth_login.dart';
import 'package:kasirku_flutter/app/domain/usecase/order_get_all.dart';
import 'package:kasirku_flutter/app/domain/usecase/order_get_today.dart';
import 'package:kasirku_flutter/app/domain/usecase/product_get_all.dart';
import 'package:kasirku_flutter/app/domain/usecase/product_get_by_barcode.dart';
import 'package:kasirku_flutter/app/presentation/add_product_order/add_product_order_notifier.dart';
import 'package:kasirku_flutter/app/presentation/checkout/checkout_notifier.dart';
import 'package:kasirku_flutter/app/presentation/home/home_notifier.dart';
import 'package:kasirku_flutter/app/presentation/input_order/input_order_notifier.dart';
import 'package:kasirku_flutter/app/presentation/login/login_notifier.dart';
import 'package:kasirku_flutter/app/presentation/order/order_notifier.dart';
import 'package:kasirku_flutter/app/presentation/print/print_notifier.dart';
import 'package:kasirku_flutter/app/presentation/profil/profil_notifier.dart';
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

  //api service
  sl.registerSingleton<AuthApiService>(AuthApiService(sl()));
  sl.registerSingleton<OrderApiService>(OrderApiService(sl()));
  sl.registerSingleton<ProductApiService>(ProductApiService(sl()));

  //repository
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl(sl()));
  sl.registerSingleton<OrderRepository>(OrderRepositoryImpl(sl()));
  sl.registerSingleton<ProductRepository>(ProductRepositoryImpl(sl()));

  //use case
  sl.registerSingleton<AuthLoginUseCase>(AuthLoginUseCase(sl()));
  sl.registerSingleton<OrderGetTodayUseCase>(OrderGetTodayUseCase(sl()));
  sl.registerSingleton<OrderGetAllUseCase>(OrderGetAllUseCase(sl()));
  sl.registerSingleton<ProductGetAllUseCase>(ProductGetAllUseCase(sl()));
  sl.registerSingleton<ProductGetByBarcodeUseCase>(
      ProductGetByBarcodeUseCase(sl()));

  //presentation
  sl.registerFactoryParam<LoginNotifier, void, void>(
      (param1, param2) => LoginNotifier(sl()));

  sl.registerFactoryParam<HomeNotifier, void, void>(
      (param1, param2) => HomeNotifier(sl()));

  sl.registerFactoryParam<OrderNotifier, void, void>(
      (param1, param2) => OrderNotifier(sl()));

  sl.registerFactoryParam<InputOrderNotifier, void, void>(
      (param1, param2) => InputOrderNotifier(sl()));

  sl.registerFactoryParam<AddProductOrderNotifier, List<ProductItemOrderEntity>,
      void>((param1, param2) => AddProductOrderNotifier(param1, sl()));

  sl.registerFactoryParam<CheckoutNotifier, void, void>(
      (param1, param2) => CheckoutNotifier());

  sl.registerFactoryParam<PrintNotifier, void, void>(
      (param1, param2) => PrintNotifier());

  sl.registerFactoryParam<ProfilNotifier, void, void>(
      (param1, param2) => ProfilNotifier());
}
