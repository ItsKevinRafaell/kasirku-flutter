import 'package:kasirku_flutter/app/domain/entity/auth.dart';
import 'package:kasirku_flutter/core/network/data_state.dart';

abstract class AuthRepository {
  Future<DataState> login(AuthEntity param);
}
