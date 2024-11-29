import 'package:kasirku_flutter/app/domain/entity/setting.dart';
import 'package:kasirku_flutter/core/network/data_state.dart';

abstract class SettingRepository {
  Future<DataState<SettingEntity>> get();
}
