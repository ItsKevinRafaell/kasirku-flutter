import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kasirku_flutter/app/domain/entity/product.dart';
import 'package:kasirku_flutter/app/presentation/add_product_order/add_product_order_screen.dart';
import 'package:kasirku_flutter/app/presentation/checkout/checkout_screen.dart';
import 'package:kasirku_flutter/app/presentation/input_order/input_order_notifier.dart';
import 'package:kasirku_flutter/core/helper/date_time_helper.dart';
import 'package:kasirku_flutter/core/helper/dialog_helper.dart';
import 'package:kasirku_flutter/core/helper/global_helper.dart';
import 'package:kasirku_flutter/core/helper/number_helper.dart';
import 'package:kasirku_flutter/core/widget/app_widget.dart';

class InputOrderScreen extends AppWidget<InputOrderNotifier, void, void> {
  @override
  AppBar? appBarBuild(BuildContext context) {
    return AppBar(
      title: Text('Create Order'),
      actions: [
        IconButton(
            onPressed: () => _showDialogCustomer(context),
            icon: Icon(Icons.person))
      ],
    );
  }

  @override
  Widget bodyBuild(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Produk dipesan',
                  style: GlobalHelper.getTextTheme(context,
                          appTextStyle: AppTextStyle.TITLE_LARGE)
                      ?.copyWith(
                          color: GlobalHelper.getColorSchema(context).primary),
                ),
              ),
              IconButton.outlined(
                  onPressed: () {},
                  // onPressed: () => _onPressBarcode(),
                  icon: Icon(Icons.qr_code_scanner)),
              IconButton.filled(
                  onPressed: () => _onPressAddOrder(context),
                  icon: Icon(Icons.add)),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => SizedBox(height: 10),
              itemCount: notifier.listOrderItem.length,
              itemBuilder: (context, index) {
                final item = notifier.listOrderItem[index];
                return _itemOrderLayout(context, item);
              }),
          SizedBox(height: 10),
          Container(
              width: double.maxFinite,
              child: FilledButton(
                onPressed: () => _onPressCheckout(context),
                child: Text('Checkout'),
              ))
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
                  onPressed: () => _onPressRemoveQuantity(item),
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

  _showDialogCustomer(BuildContext context) {
    DialogHelper.showBottomSheetDialog(
        context: context,
        title: 'Pembeli',
        content: Column(
          children: [
            TextField(
              controller: notifier.nameController,
              decoration: InputDecoration(
                  label: Text('Nama'),
                  border: OutlineInputBorder(),
                  errorText: notifier.errorCustomer[InputOrderNotifier.NAME]),
            ),
            SizedBox(height: 10),
            DropdownMenu<String>(
              expandedInsets: EdgeInsets.symmetric(horizontal: 1),
              label: Text('Gender'),
              errorText: notifier.errorCustomer[InputOrderNotifier.GENDER],
              controller: notifier.genderController,
              dropdownMenuEntries: notifier.genderListDropdown,
            ),
            SizedBox(height: 10),
            TextField(
              controller: notifier.notesController,
              decoration: InputDecoration(
                label: Text('Notes'),
                border: OutlineInputBorder(),
              ),
              maxLines: null,
            ),
            SizedBox(height: 10),
            TextField(
              controller: notifier.emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                label: Text('Email'),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: notifier.phoneController,
              decoration: InputDecoration(
                label: Text('Phone'),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 10),
            TextField(
              readOnly: true,
              controller: notifier.birthdayController,
              onTap: () => _onPressBirthday(context),
              decoration: InputDecoration(
                label: Text('Birthday'),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Container(
                width: double.maxFinite,
                child: FilledButton(
                    onPressed: () => _onPressSaveCustomer(context),
                    child: Text('Simpan')))
          ],
        ));
  }

  _onPressSaveCustomer(BuildContext context) {
    Navigator.pop(context);
    notifier.validateCustomer();
  }

  _onPressBirthday(BuildContext context) async {
    DateTime? birthday = await showDatePicker(
        context: context,
        firstDate: DateTime(DateTime.now().year - 100),
        lastDate: DateTime.now());
    notifier.birthdayController.text =
        DateTimeHelper.formatDateTime(dateTime: birthday, format: 'yyyy-MM-dd');
  }

  _onPressAddOrder(BuildContext context) async {
    final List<ProductItemOrderEntity>? items = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AddProductOrderScreen(param1: notifier.listOrderItem)));
    if (items != null) notifier.updateItems(items);
  }

  _onPressCheckout(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckoutScreen(param1: notifier.order),
        ));
    notifier.init();
  }

  @override
  checkVariable(BuildContext context) {
    if (notifier.isShowCustomer || notifier.errorCustomer.isNotEmpty) {
      notifier.isShowCustomer = false;
      _showDialogCustomer(context);
    }
  }

  _onPressRemoveQuantity(ProductItemOrderEntity item) {
    notifier.updateQuantity(item, item.quantity - 1);
  }

  _onPressAddQuantity(ProductItemOrderEntity item) {
    notifier.updateQuantity(item, item.quantity + 1);
  }

  // _onPressScan(BuildContext context) {
  //   QrBarCodeScannerDialog().getScannedQrBarCode(
  //       context: context,
  //       onCode: (code) {
  //         notifier.scan(code ?? '');
  //       });
  // }
}
