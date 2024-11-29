import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kasirku_flutter/app/presentation/checkout/checkout_notifier.dart';
import 'package:kasirku_flutter/app/presentation/print/print_screen.dart';
import 'package:kasirku_flutter/core/helper/global_helper.dart';
import 'package:kasirku_flutter/core/widget/app_widget.dart';

class CheckoutScreen extends AppWidget<CheckoutNotifier, void, void> {
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
              Text(': nama_customer')
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Icon(Icons.male),
              SizedBox(width: 3),
              Text(': laki-laki')
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Icon(Icons.email),
              SizedBox(width: 3),
              Text(': custom@gmail.com')
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Icon(Icons.phone),
              SizedBox(width: 3),
              Text(': +62xxxxx')
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Icon(Icons.event),
              SizedBox(width: 3),
              Text(': 23 Oktober 2002')
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
              Expanded(child: Text('Catatn pembeli'))
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
            decoration: InputDecoration(
                label: Text('Total Pembayaran'), border: OutlineInputBorder()),
          ),
          SizedBox(height: 5),
          TextField(
            decoration: InputDecoration(
                label: Text('Metode Pembayaran'), border: OutlineInputBorder()),
          ),
          SizedBox(height: 5),
          TextField(
            decoration: InputDecoration(
                label: Text('Nominal Bayar'), border: OutlineInputBorder()),
          ),
          SizedBox(height: 5),
          TextField(
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
            itemCount: 5,
            itemBuilder: (context, index) => _itemProductLayout(context),
          )
        ]));
  }

  _itemProductLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'nama_produk',
          style: GlobalHelper.getTextTheme(context,
              appTextStyle: AppTextStyle.BODY_MEDIUM),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '1 x Rp.50.000',
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
