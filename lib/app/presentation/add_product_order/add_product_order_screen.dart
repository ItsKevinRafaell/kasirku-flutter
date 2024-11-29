import 'package:flutter/material.dart';
import 'package:flutter/src/material/app_bar.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kasirku_flutter/app/presentation/add_product_order/add_product_order_notifier.dart';
import 'package:kasirku_flutter/core/helper/global_helper.dart';
import 'package:kasirku_flutter/core/widget/app_widget.dart';

class AddProductOrderScreen
    extends AppWidget<AddProductOrderNotifier, void, void> {
  @override
  AppBar? appBarBuild(BuildContext context) {
    return AppBar(
      title: Text('Tambah produk'),
    );
  }

  @override
  Widget bodyBuild(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: TextField(
                      decoration: InputDecoration(
                label: Text('Cari Produk'),
                border: OutlineInputBorder(),
              ))),
              IconButton.outlined(
                  onPressed: () {}, icon: Icon(Icons.qr_code_scanner)),
            ],
          ),
          Expanded(
            child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 5),
                itemCount: 15,
                itemBuilder: (context, index) {
                  return _itemOrderLayout(context);
                }),
          ),
          Row(
            children: [
              Expanded(
                  child: Text(
                '2 Item',
                style: GlobalHelper.getTextTheme(context,
                    appTextStyle: AppTextStyle.TITLE_MEDIUM),
              )),
              SizedBox(width: 5),
              FilledButton(onPressed: () {}, child: Text('Simpan'))
            ],
          )
        ],
      ),
    ));
  }

  _itemOrderLayout(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: GlobalHelper.getColorSchema(context).surfaceContainer,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text('nama_produk',
                      style: GlobalHelper.getTextTheme(context,
                          appTextStyle: AppTextStyle.BODY_MEDIUM))),
              Text('Rp. 5000',
                  style: GlobalHelper.getTextTheme(context,
                          appTextStyle: AppTextStyle.BODY_LARGE)
                      ?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: GlobalHelper.getColorSchema(context).primary)),
            ],
          ),
          Row(
            children: [
              Text(
                'Stok: 50',
                style: GlobalHelper.getTextTheme(context,
                    appTextStyle: AppTextStyle.BODY_MEDIUM),
              ),
              Expanded(child: SizedBox()),
              IconButton.outlined(onPressed: () {}, icon: Icon(Icons.remove)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: GlobalHelper.getColorSchema(context).shadow,
                        width: 0.5),
                    borderRadius: BorderRadius.circular(4)),
                child: Text(
                  '1',
                  style: GlobalHelper.getTextTheme(context,
                      appTextStyle: AppTextStyle.BODY_MEDIUM),
                ),
              ),
              IconButton.outlined(
                onPressed: () {},
                icon: Icon(Icons.add),
              )
            ],
          )
        ],
      ),
    );
  }
}
