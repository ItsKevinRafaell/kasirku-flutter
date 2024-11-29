import 'package:freezed_annotation/freezed_annotation.dart';

part 'setting.g.dart';
part 'setting.freezed.dart';

@freezed
sealed class Setting with _$Setting {
  const factory Setting.entity({
    required String shop,
    required String address,
    required String phone,
  }) = SettingEntity;

  factory Setting.fromJson(Map<String, dynamic> json) =>
      _$SettingFromJson(json);
}
