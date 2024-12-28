import 'package:flutter/material.dart';
import 'package:flutter/src/material/app_bar.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kasirku_flutter/app/domain/entity/order.dart';
import 'package:kasirku_flutter/app/domain/entity/product.dart';
import 'package:kasirku_flutter/app/presentation/checkout/checkout_notifier.dart';
import 'package:kasirku_flutter/app/presentation/detail_order/detail_order_notifier.dart';
import 'package:kasirku_flutter/app/presentation/print/print_screen.dart';
import 'package:kasirku_flutter/core/helper/date_time_helper.dart';
import 'package:kasirku_flutter/core/helper/global_helper.dart';
import 'package:kasirku_flutter/core/helper/number_helper.dart';
import 'package:kasirku_flutter/core/widget/app_widget.dart';

class DetailOrderScreen extends AppWidget<DetailOrderNotifier, int, void> {
  DetailOrderScreen({required super.param1});

  @override
  AppBar? appBarBuild(BuildContext context) {
    return AppBar(
      title: Text('Detail Order'),
    );
  }

  @override
  Widget bodyBuild(BuildContext context) {
    return ListView(
      children: [
        _customerLayout(context),
        _separator(context),
        _productLayout(context),
        _separator(context),
        _paymentLayout(context),
        SizedBox(height: 30),
        Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: FilledButton(
              onPressed: () => _onPressPrint(context),
              child: Text('Print Invoice')),
        )
      ],
    );
  }

  _separator(BuildContext context) {
    return Container(
      height: 3,
      margin: EdgeInsets.symmetric(vertical: 3),
      color: GlobalHelper.getColorSchema(context).outline,
    );
  }

  _customerLayout(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pembeli',
            style: GlobalHelper.getTextTheme(context,
                appTextStyle: AppTextStyle.TITLE_MEDIUM),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.person),
              const SizedBox(width: 3),
              Text(': ${notifier.order!.name}')
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Icon((notifier.order?.gender == CheckoutNotifier.MALE)
                  ? Icons.male
                  : Icons.female),
              const SizedBox(width: 3),
              Text(
                  ': ${(notifier.order!.gender == CheckoutNotifier.MALE) ? 'Laki-laki' : 'Perempuan'}')
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.email),
              const SizedBox(width: 3),
              Text(': ${notifier.order?.email ?? '-'}')
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.phone),
              const SizedBox(width: 3),
              Text(': ${notifier.order?.phone ?? '-'}')
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.event),
              const SizedBox(width: 3),
              Text(
                  ': ${notifier.order?.birthday != null ? DateTimeHelper.formatDateTimeFromString(dateTimeString: notifier.order!.birthday!, format: 'dd MMM yyy') : '-'}')
            ],
          ),
          const SizedBox(height: 5),
          const Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text('Notes : '),
          ),
          Row(
            children: [
              const SizedBox(width: 25),
              Expanded(child: Text(': ${notifier.order?.notes ?? '-'}'))
            ],
          ),
        ],
      ),
    );
  }

  _productLayout(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Produk dipesan',
            style: GlobalHelper.getTextTheme(context,
                appTextStyle: AppTextStyle.TITLE_MEDIUM),
          ),
          const SizedBox(height: 10),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => Column(
              children: [SizedBox(height: 5)],
            ),
            itemCount: notifier.order!.items.length,
            itemBuilder: (context, index) {
              final item = notifier.order!.items[index];
              return _itemProductLayout(context, item);
            },
          )
        ]));
  }

  _itemProductLayout(BuildContext context, ProductItemOrderEntity item) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(
              color: GlobalHelper.getColorSchema(context).outline, width: 1),
          borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.name,
            style: GlobalHelper.getTextTheme(context,
                appTextStyle: AppTextStyle.BODY_MEDIUM),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${item.quantity} x ${NumberHelper.formatIdr(item.price)}',
              style: GlobalHelper.getTextTheme(context,
                      appTextStyle: AppTextStyle.BODY_LARGE)
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  _paymentLayout(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rincian Pembayaran',
            style: GlobalHelper.getTextTheme(context,
                appTextStyle: AppTextStyle.TITLE_MEDIUM),
          ),
          SizedBox(height: 10),
          _itemPaymentLayout(
              context, 'Metode', notifier.order!.paymentMethod!.name),
          SizedBox(height: 5),
          _itemPaymentLayout(context, 'Total Bayar',
              NumberHelper.formatIdr(notifier.order!.totalPrice ?? 0)),
          SizedBox(height: 5),
          _itemPaymentLayout(context, 'Nominal',
              NumberHelper.formatIdr(notifier.order!.paidAmount ?? 0)),
          SizedBox(height: 5),
          _itemPaymentLayout(context, 'Kembalian',
              NumberHelper.formatIdr(notifier.order!.changeAmount ?? 0)),
        ],
      ),
    );
  }

  _itemPaymentLayout(BuildContext context, String label, String value) {
    return Row(
      children: [
        Expanded(
            child: Text(
          label,
          style: GlobalHelper.getTextTheme(context,
              appTextStyle: AppTextStyle.BODY_MEDIUM),
        )),
        Text(
          value,
          style: GlobalHelper.getTextTheme(context,
                  appTextStyle: AppTextStyle.BODY_LARGE)
              ?.copyWith(fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  _onPressPrint(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PrintScreen(param1: notifier.order)),
    );
  }
}
