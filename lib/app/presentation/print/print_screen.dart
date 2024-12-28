import 'package:flutter/material.dart';
import 'package:kasirku_flutter/app/domain/entity/order.dart';
import 'package:kasirku_flutter/app/presentation/print/print_notifier.dart';
import 'package:kasirku_flutter/core/helper/global_helper.dart';
import 'package:kasirku_flutter/core/widget/app_widget.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class PrintScreen extends AppWidget<PrintNotifier, OrderEntity, void> {
  PrintScreen({required super.param1});

  @override
  AppBar? appBarBuild(BuildContext context) {
    return AppBar(
      title: const Text('Cetak Invoice'),
    );
  }

  @override
  Widget bodyBuild(BuildContext context) {
    return SafeArea(
        child: Container(
      padding: const EdgeInsets.all(10),
      width: double.maxFinite,
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Icon(Icons.check_circle, size: 75, color: Colors.green),
          const SizedBox(height: 20),
          Text('Order berhasil dicetak',
              style: GlobalHelper.getTextTheme(context,
                  appTextStyle: AppTextStyle.DISPLAY_SMALL)),
          const SizedBox(height: 20),
          _deviceLayout(context),
        ],
      ),
    ));
  }

  _deviceLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Daftar Printer',
            style: GlobalHelper.getTextTheme(context,
                appTextStyle: AppTextStyle.TITLE_MEDIUM)),
        const SizedBox(height: 10),
        ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemCount: notifier.listBluetooth.length,
            itemBuilder: (context, index) {
              final item = notifier.listBluetooth[index];
              return _itemDeviceLayout(context, item);
            })
      ],
    );
  }

  _itemDeviceLayout(BuildContext context, BluetoothInfo item) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
            color: GlobalHelper.getColorSchema(context).shadow, width: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.bluetooth_connected),
          const SizedBox(width: 10),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text('${item.name}'), Text('${item.macAdress}')],
          )),
          const SizedBox(width: 5),
          FilledButton(
              onPressed: () => _onPressPrint(item), child: const Text('Cetak'))
        ],
      ),
    );
  }

  _onPressPrint(BluetoothInfo item) {
    notifier.print(item.macAdress);
  }
}
