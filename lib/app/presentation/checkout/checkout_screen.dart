import 'package:flutter/material.dart';
import 'package:kasirku_flutter/app/domain/entity/order.dart';
import 'package:kasirku_flutter/app/domain/entity/product.dart';
import 'package:kasirku_flutter/app/presentation/checkout/checkout_notifier.dart';
import 'package:kasirku_flutter/app/presentation/print/print_screen.dart';
import 'package:kasirku_flutter/core/helper/date_time_helper.dart';
import 'package:kasirku_flutter/core/helper/global_helper.dart';
import 'package:kasirku_flutter/core/helper/number_helper.dart';
import 'package:kasirku_flutter/core/widget/app_widget.dart';

class CheckoutScreen extends AppWidget<CheckoutNotifier, OrderEntity, void> {
  CheckoutScreen({super.key, required super.param1});
  @override
  AppBar? appBarBuild(BuildContext context) {
    return AppBar(
      title: const Text('Checkout'),
    );
  }

  @override
  Widget bodyBuild(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          _customerLayout(context),
          const SizedBox(height: 20),
          _productLayout(context),
          const SizedBox(height: 20),
          _paymentLayout(context),
          const SizedBox(height: 20),
          SizedBox(
              width: double.maxFinite,
              child: FilledButton(
                  onPressed: () => _onPressSend(context),
                  child: const Text(
                    'Kirim',
                  )))
        ],
      ),
    ));
  }

  _customerLayout(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(
              color: GlobalHelper.getColorSchema(context).shadow, width: 0.5),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
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
              Text(': ${notifier.order.name}')
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Icon((notifier.order.gender == CheckoutNotifier.MALE)
                  ? Icons.male
                  : Icons.female),
              const SizedBox(width: 3),
              Text(
                  ': ${(notifier.order.gender == CheckoutNotifier.MALE) ? 'Laki-laki' : 'Perempuan'}')
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.email),
              const SizedBox(width: 3),
              Text(': ${notifier.order.email ?? '-'}')
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.phone),
              const SizedBox(width: 3),
              Text(': ${notifier.order.phone ?? '-'}')
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.event),
              const SizedBox(width: 3),
              Text(
                  ': ${(notifier.order.birthday != null) ? DateTimeHelper.formatDateTimeFromString(dateTimeString: notifier.order.birthday!, format: 'd MMM yyyy') : '-'}')
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
              Expanded(child: Text(notifier.order.notes ?? '-'))
            ],
          ),
        ],
      ),
    );
  }

  _paymentLayout(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(
              color: GlobalHelper.getColorSchema(context).shadow, width: 0.5),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Text(
            'Pembayaran',
            style: GlobalHelper.getTextTheme(context,
                appTextStyle: AppTextStyle.TITLE_MEDIUM),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: notifier.totalController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                label: Text('Total Pembayaran'), border: OutlineInputBorder()),
          ),
          const SizedBox(height: 5),
          DropdownMenu<int>(
            expandedInsets: const EdgeInsets.symmetric(horizontal: 1),
            label: const Text('Metode Pembayaran'),
            dropdownMenuEntries: notifier.listDropdownPaymentMethod,
            initialSelection: notifier.initialPaymentMethod,
            controller: notifier.methodController,
          ),
          const SizedBox(height: 5),
          TextField(
            controller: notifier.amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                label: Text('Nominal Bayar'), border: OutlineInputBorder()),
          ),
          const SizedBox(height: 5),
          TextField(
            controller: notifier.changeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                label: Text('Kembalian'), border: OutlineInputBorder()),
          ),
        ],
      ),
    );
  }

  _productLayout(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(
                color: GlobalHelper.getColorSchema(context).shadow, width: 0.5),
            borderRadius: BorderRadius.circular(10)),
        child: Column(children: [
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
              children: [
                const SizedBox(height: 3),
                Container(
                  height: 0.5,
                  color: GlobalHelper.getColorSchema(context).shadow,
                ),
                const SizedBox(height: 3)
              ],
            ),
            itemCount: notifier.order.items.length,
            itemBuilder: (context, index) {
              final item = notifier.order.items[index];
              return _itemProductLayout(context, item);
            },
          )
        ]));
  }

  _itemProductLayout(BuildContext context, ProductItemOrderEntity item) {
    return Column(
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
    );
  }

  _onPressSend(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PrintScreen()));
  }
}
