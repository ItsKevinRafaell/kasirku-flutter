import 'package:kasirku_flutter/app/domain/entity/order.dart';
import 'package:kasirku_flutter/app/domain/entity/setting.dart';
import 'package:kasirku_flutter/app/domain/usecase/setting_get.dart';
import 'package:kasirku_flutter/core/helper/date_time_helper.dart';
import 'package:kasirku_flutter/core/helper/number_helper.dart';
import 'package:kasirku_flutter/core/provider/app_provider.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';

class PrintNotifier extends AppProvider {
  final OrderEntity _orderEntity;
  final SettingGetUseCase _settingGetUseCase;

  PrintNotifier(this._orderEntity, this._settingGetUseCase) {
    init();
  }

  SettingEntity? _settingStore;
  List<BluetoothInfo> _listBluetooth = [];

  List<BluetoothInfo> get listBluetooth => _listBluetooth;

  @override
  init() async {
    await _getSetting();
    await _getBluetoothStatus();
    if (errorMessage.isEmpty) await _getBluetoothPaired();
  }

  _getSetting() async {
    showLoading();
    final response = await _settingGetUseCase();
    if (response.success) {
      _settingStore = response.data!;
    } else {
      errorMessage = response.message;
    }
    hideLoading();
  }

  _getBluetoothStatus() async {
    showLoading();
    if (!await PrintBluetoothThermal.isPermissionBluetoothGranted) {
      errorMessage = 'Harap berikan perizinan bluetooth';
    } else if (!await PrintBluetoothThermal.bluetoothEnabled) {
      errorMessage = 'Harap aktifkan bluetooth';
    }
    hideLoading();
  }

  _getBluetoothPaired() async {
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
      snackBarMessage = 'Tidak dapat terhubung pada bluetooth yang dipilih';
    }
    hideLoading();
  }

  Future<List<int>> _generateInvoice() async {
    final date = DateTimeHelper.formatDateTime(
        dateTime: DateTime.now(), format: 'dd MMM yyyy HH:mm:ss');
    final Generator ticket =
        Generator(PaperSize.mm58, await CapabilityProfile.load());
    List<int> bytes = [];
    if (_settingStore?.shop?.isNotEmpty ?? false) {
      bytes += ticket.text(_settingStore?.shop ?? '-',
          styles: const PosStyles(
              align: PosAlign.center,
              height: PosTextSize.size2,
              width: PosTextSize.size2));
    }
    if (_settingStore?.address?.isNotEmpty ?? false) {
      bytes += ticket.text(_settingStore?.address ?? '-',
          styles: const PosStyles(align: PosAlign.center));
    }

    if (_settingStore?.phone?.isNotEmpty ?? false) {
      bytes += ticket.text('Telp : ${_settingStore?.phone ?? '-'}',
          styles: const PosStyles(align: PosAlign.center));
    }
    bytes += ticket.feed(1);
    bytes += ticket.text(date, styles: const PosStyles(align: PosAlign.center));

    bytes += ticket.feed(2);
    bytes += ticket.hr(ch: '=');
    bytes += ticket.text('Produk yang dipesan',
        styles: const PosStyles(align: PosAlign.center));
    bytes += ticket.hr(ch: '=');
    for (var element in _orderEntity.items) {
        bytes += ticket.text(element.name, styles: const PosStyles());
        bytes += ticket.row([
          PosColumn(text: '', width: 4),
          PosColumn(
              text: NumberHelper.formatIdr(element.price),
              width: 3,
              styles: const PosStyles(align: PosAlign.right)),
          PosColumn(
              text: '${element.quantity}',
              width: 2,
              styles: const PosStyles(align: PosAlign.right)),
          PosColumn(
              text: NumberHelper.formatIdr(element.price * element.quantity),
              width: 3,
              styles: const PosStyles(align: PosAlign.right)),
        ]);
      }

    bytes += ticket.hr();
    bytes += ticket.row([
      PosColumn(
          text: 'TOTAL', width: 6, styles: const PosStyles(align: PosAlign.right)),
      PosColumn(
          text: NumberHelper.formatIdr(_orderEntity.totalPrice!),
          width: 6,
          styles: const PosStyles(align: PosAlign.right)),
    ]);
    bytes += ticket.hr(ch: '=');
    bytes += ticket.row([
      PosColumn(
          text: 'Paid', width: 6, styles: const PosStyles(align: PosAlign.right)),
      PosColumn(
          text: NumberHelper.formatIdr(_orderEntity.paidAmount!),
          width: 6,
          styles: const PosStyles(align: PosAlign.right)),
    ]);

    bytes += ticket.row([
      PosColumn(
          text: 'Change', width: 6, styles: const PosStyles(align: PosAlign.right)),
      PosColumn(
          text: NumberHelper.formatIdr(_orderEntity.changeAmount!),
          width: 6,
          styles: const PosStyles(align: PosAlign.right)),
    ]);

    bytes += ticket.feed(2);
    bytes +=
        ticket.text('Terima kasih', styles: const PosStyles(align: PosAlign.center));
    ticket.feed(2);
    return bytes;
  }
}
