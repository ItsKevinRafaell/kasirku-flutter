import 'package:flutter/material.dart';
import 'package:kasirku_flutter/app/presentation/product/product_notifier.dart';
import 'package:kasirku_flutter/core/helper/global_helper.dart';
import 'package:kasirku_flutter/core/helper/number_helper.dart';
import 'package:kasirku_flutter/core/widget/app_widget.dart';
import 'package:kasirku_flutter/core/widget/widget_network_app_widget.dart';

class ProductScreen extends AppWidget<ProductNotifier, void, void> {
  ProductScreen({super.key});

  @override
  AppBar? appBarBuild(BuildContext context) {
    return AppBar(
      title: const Text('Product'),
    );
  }

  @override
  Widget bodyBuild(BuildContext context) {
    return SafeArea(
        child: ListView.separated(
            separatorBuilder: (context, index) => Container(
                  height: 3,
                  color: GlobalHelper.getColorSchema(context).outline,
                ),
            itemCount: 5,
            itemBuilder: (context, index) {
              return _itemLayout(context);
            }));
  }

  _itemLayout(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: [
          const ImageNetworkAppWidget(
            imageUrl: '',
            width: 50,
            height: 50,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'nama_product',
                  style: GlobalHelper.getTextTheme(context,
                      appTextStyle: AppTextStyle.TITLE_SMALL),
                ),
                const SizedBox(height: 2),
                Text(
                  NumberHelper.formatIdr(20000),
                  style: GlobalHelper.getTextTheme(context,
                      appTextStyle: AppTextStyle.BODY_LARGE),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Stok : 23',
                      style: GlobalHelper.getTextTheme(context,
                          appTextStyle: AppTextStyle.LABEL_MEDIUM),
                    ),
                    Text(
                      'Active',
                      style: GlobalHelper.getTextTheme(context,
                              appTextStyle: AppTextStyle.LABEL_MEDIUM)
                          ?.copyWith(color: Colors.green),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
