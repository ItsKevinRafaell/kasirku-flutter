import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kasirku_flutter/app/domain/entity/order.dart';
import 'package:kasirku_flutter/app/domain/entity/product.dart';
import 'package:kasirku_flutter/app/presentation/checkout/checkout_notifier.dart';
import 'package:kasirku_flutter/app/presentation/print/print_screen.dart';
import 'package:kasirku_flutter/core/helper/date_time_helper.dart';
import 'package:kasirku_flutter/core/helper/global_helper.dart';
import 'package:kasirku_flutter/core/helper/number_helper.dart';
import 'package:kasirku_flutter/core/widget/app_widget.dart';

class CheckoutScreen extends AppWidget<CheckoutNotifier, OrderEntity, void> {
  CheckoutScreen({required super.param1});
  @override
  AppBar? appBarBuild(BuildContext context) {
    return AppBar(
      title: Text('Checkout'),
    );
  }

  @override
  Widget bodyBuild(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          _customerLayout(context),
          SizedBox(height: 20),
          _productLayout(context),
          SizedBox(height: 20),
          _paymentLayout(context),
          SizedBox(height: 20),
          Container(
              width: double.maxFinite,
              child: FilledButton(
                  onPressed: () => _onPressSend(context),
                  child: Text(
                    'Kirim',
                  )))
        ],
      ),
    ));
  }

  _customerLayout(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
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
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.person),
              SizedBox(width: 3),
              Text(': ${notifier.order.name}')
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Icon((notifier.order.gender == CheckoutNotifier.MALE)
                  ? Icons.male
                  : Icons.female),
              SizedBox(width: 3),
              Text(
                  ': ${(notifier.order.gender == CheckoutNotifier.MALE) ? 'Laki-laki' : 'Perempuan'}')
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Icon(Icons.email),
              SizedBox(width: 3),
              Text(': ${notifier.order.email ?? '-'}')
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Icon(Icons.phone),
              SizedBox(width: 3),
              Text(': ${notifier.order.phone ?? '-'}')
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Icon(Icons.event),
              SizedBox(width: 3),
              Text(
                  ': ${(notifier.order.birthday != null) ? DateTimeHelper.formatDateTimeFromString(dateTimeString: notifier.order.birthday!, format: 'd MMM yyyy') : '-'}')
            ],
          ),
          SizedBox(height: 5),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text('Notes : '),
          ),
          Row(
            children: [
              SizedBox(width: 25),
              Expanded(child: Text('${notifier.order.notes ?? '-'}'))
            ],
          ),
        ],
      ),
    );
  }

  _paymentLayout(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
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
          SizedBox(height: 10),
          TextField(
            controller: notifier.totalController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                label: Text('Total Pembayaran'), border: OutlineInputBorder()),
          ),
          SizedBox(height: 5),
          DropdownMenu<int>(
            expandedInsets: EdgeInsets.symmetric(horizontal: 1),
            label: Text('Metode Pembayaran'),
            dropdownMenuEntries: notifier.listDropdownPaymentMethod,
            initialSelection: notifier.initialPaymentMethod,
            controller: notifier.methodController,
          ),
          SizedBox(height: 5),
          TextField(
            controller: notifier.amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                label: Text('Nominal Bayar'), border: OutlineInputBorder()),
          ),
          SizedBox(height: 5),
          TextField(
            controller: notifier.changeController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                label: Text('Kembalian'), border: OutlineInputBorder()),
          ),
        ],
      ),
    );
  }

  _productLayout(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
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
          SizedBox(height: 10),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => Column(
              children: [
                SizedBox(height: 3),
                Container(
                  height: 0.5,
                  color: GlobalHelper.getColorSchema(context).shadow,
                ),
                SizedBox(height: 3)
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
