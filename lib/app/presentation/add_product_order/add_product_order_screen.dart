import 'package:flutter/material.dart';
import 'package:flutter/src/material/app_bar.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kasirku_flutter/app/domain/entity/product.dart';
import 'package:kasirku_flutter/app/presentation/add_product_order/add_product_order_notifier.dart';
import 'package:kasirku_flutter/core/helper/global_helper.dart';
import 'package:kasirku_flutter/core/helper/number_helper.dart';
import 'package:kasirku_flutter/core/widget/app_widget.dart';

class AddProductOrderScreen extends AppWidget<AddProductOrderNotifier,
    List<ProductItemOrderEntity>, void> {
  AddProductOrderScreen({required super.param1});

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
                      controller: notifier.searchController,
                      decoration: InputDecoration(
                        hintText: 'Tuliskan nama atau barcode produk',
                        label: Text('Cari Produk'),
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                            onPressed: () => _onPressClearSearch(),
                            icon: Icon(Icons.clear)),
                      ),
                      onSubmitted: (value) => _onSubmitSearch())),
              IconButton.outlined(
                  onPressed: () {},
                  // onPressed: () => _onPressScan(),
                  icon: Icon(Icons.qr_code_scanner)),
            ],
          ),
          Expanded(
            child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 5),
                itemCount: notifier.listOrderItem.length,
                itemBuilder: (context, index) {
                  final item = notifier.listOrderItem[index];
                  return _itemOrderLayout(context, item);
                }),
          ),
          Row(
            children: [
              Expanded(
                  child: Text(
                '${notifier.totalProduct} Item',
                style: GlobalHelper.getTextTheme(context,
                    appTextStyle: AppTextStyle.TITLE_MEDIUM),
              )),
              SizedBox(width: 5),
              FilledButton(
                  onPressed: () => _onPressSave(context), child: Text('Simpan'))
            ],
          )
        ],
      ),
    ));
  }

  _itemOrderLayout(BuildContext context, ProductItemOrderEntity item) {
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
                  child: Text(item.name,
                      style: GlobalHelper.getTextTheme(context,
                          appTextStyle: AppTextStyle.BODY_MEDIUM))),
              Text(NumberHelper.formatIdr(item.price),
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
                'Stok: ${item.stock}',
                style: GlobalHelper.getTextTheme(context,
                    appTextStyle: AppTextStyle.BODY_MEDIUM),
              ),
              Expanded(child: SizedBox()),
              IconButton.outlined(
                  onPressed: (item.quantity > 0)
                      ? () => _onPressRemoveQuantity(item)
                      : null,
                  icon: Icon(Icons.remove)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: GlobalHelper.getColorSchema(context).shadow,
                        width: 0.5),
                    borderRadius: BorderRadius.circular(4)),
                child: Text(
                  item.quantity.toString(),
                  style: GlobalHelper.getTextTheme(context,
                      appTextStyle: AppTextStyle.BODY_MEDIUM),
                ),
              ),
              IconButton.outlined(
                onPressed: (item.stock != null &&
                        item.stock! > 0 &&
                        item.stock! > item.quantity)
                    ? () => _onPressAddQuantity(item)
                    : null,
                icon: Icon(Icons.add),
              )
            ],
          )
        ],
      ),
    );
  }

  _onPressAddQuantity(ProductItemOrderEntity item) {
    notifier.updateQuantity(item, item.quantity + 1);
  }

  _onPressRemoveQuantity(ProductItemOrderEntity item) {
    notifier.updateQuantity(item, item.quantity - 1);
  }

  _onPressSave(BuildContext context) {
    Navigator.pop(context, notifier.listOrderItemFilteredQuantity);
  }

  _onSubmitSearch() {
    notifier.submitSearch();
  }

  _onPressClearSearch() {
    notifier.clearSearch();
  }

  // _onPressScan(BuildContext context) {
  //   QrBarCodeScannerDialog().getScannedQrBarCode(
  //       context: context,
  //       onCode: (code) {
  //         notifier.scan(code ?? '');
  //       });
  // }
}
