import 'package:flutter/widgets.dart';
import 'package:kasirku_flutter/app/domain/entity/order.dart';
import 'package:kasirku_flutter/app/domain/entity/setting.dart';
import 'package:kasirku_flutter/app/domain/usecase/setting_get.dart';
import 'package:kasirku_flutter/core/helper/date_time_helper.dart';
import 'package:kasirku_flutter/core/provider/app_provider.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';

class PrintNotifier extends AppProvider {
  final SettingGetUseCase _settingGetUseCase;
  final OrderEntity _orderEntity;

  PrintNotifier(this._settingGetUseCase, this._orderEntity) {
    init();
  }

  SettingEntity? _settingStore;
  List<BluetoothInfo> _listBluetooth = [];

  @override
  init() async {
    await _getSetting();
    await _getBluetoothStatus();
    if (errorMessage.isEmpty) await _getBluetoohPaired();
  }

  _getSetting() async {
    showLoading();
    final response = await _settingGetUseCase();
    if (response.success) {
      _settingStore = response.data;
    } else {
      errorMessage = response.message;
    }
    hideLoading();
  }

  _getBluetoothStatus() async {
    showLoading();
    if (!await PrintBluetoothThermal.isPermissionBluetoothGranted) {
      errorMessage = 'Harap berikan perizinan untuk bluetooth ';
    } else if (!await PrintBluetoothThermal.bluetoothEnabled) {
      errorMessage = 'Bluetooth belum diaktifkan';
    }
    hideLoading();
  }

  _getBluetoohPaired() async {
    showLoading();
    _listBluetooth = await PrintBluetoothThermal.pairedBluetooths;
    hideLoading();
  }

  print(String mac) async {
    showLoading();

    await PrintBluetoothThermal.connect(macPrinterAddress: mac);
    bool connectStatus = await PrintBluetoothThermal.connectionStatus;
    if (connectStatus) {
      List<int> ticket = await _generateInvoice();
      final result = await PrintBluetoothThermal.writeBytes(ticket);
      if (result) {
        snackBarMessage = 'Sukses print invoice';
      } else {
        snackBarMessage = 'Gagal print invoice';
      }
    } else {
      snackBarMessage = 'Gagal terhubung ke printer';
    }
    hideLoading();
  }

  Future<List<int>> _generateInvoice() async {
    final date = DateTimeHelper.formatDateTime(
        dateTime: DateTime.now(), format: 'dd-MM-yyyy HH:mm:ss');
    final Generator ticker =
        Generator(PaperSize.mm58, await CapabilityProfile.load());
    List<int> bytes = [];
    if (_settingStore?.shop?.isNotEmpty ?? false)
      bytes += await ticker.text(_settingStore!.shop ?? '-',
          styles: PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          ));
    if (_settingStore?.address?.isNotEmpty ?? false)
      bytes += await ticker.text(_settingStore!.address ?? '-',
          styles: PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size2,
          ));
  }
}
