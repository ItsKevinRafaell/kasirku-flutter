import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kasirku_flutter/app/domain/entity/order.dart';
import 'package:kasirku_flutter/app/presentation/input_order/input_order_screen.dart';
import 'package:kasirku_flutter/app/presentation/order/order_notifier.dart';
import 'package:kasirku_flutter/core/helper/date_time_helper.dart';
import 'package:kasirku_flutter/core/helper/global_helper.dart';
import 'package:kasirku_flutter/core/helper/number_helper.dart';
import 'package:kasirku_flutter/core/widget/app_widget.dart';

class OrderScreen extends AppWidget<OrderNotifier, void, void> {
  @override
  Widget bodyBuild(BuildContext context) {
    return SafeArea(
        child: RefreshIndicator(
            onRefresh: () => notifier.init(),
            child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(
                      height: 5,
                    ),
                itemCount: notifier.listOrder.length,
                itemBuilder: (context, index) {
                  final item =
                      notifier.listOrder[notifier.listOrder.length - 1 - index];
                  return _itemOrderLayout(context, item);
                })));
  }

  @override
  AppBar? appBarBuild(BuildContext context) {
    return AppBar(title: Text('Order'));
  }

  @override
  Widget? floatingActionButtonBuild(BuildContext context) {
    return FloatingActionButton(
        onPressed: () => _onPressAddOrder(context), child: Icon(Icons.add));
  }

  _itemOrderLayout(BuildContext context, OrderEntity item) {
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.white),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.name,
                  style: GlobalHelper.getTextTheme(context,
                          appTextStyle: AppTextStyle.BODY_LARGE)
                      ?.copyWith(
                          color: GlobalHelper.getColorSchema(context).primary,
                          fontWeight: FontWeight.bold)),
              Text(
                  DateTimeHelper.formatDateTimeFromString(
                      dateTimeString: item.updatedAt,
                      format: 'dd MMM yyyy HH:mm'),
                  style: GlobalHelper.getTextTheme(context,
                          appTextStyle: AppTextStyle.BODY_SMALL)
                      ?.copyWith(
                          color:
                              GlobalHelper.getColorSchema(context).secondary)),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  '${NumberHelper.formatIdr(item.totalPrice!)} (${item.items.length} item)',
                  style: GlobalHelper.getTextTheme(context,
                          appTextStyle: AppTextStyle.BODY_MEDIUM)
                      ?.copyWith(
                          color: GlobalHelper.getColorSchema(context).primary,
                          fontWeight: FontWeight.bold)),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                  child: Text(item.paymentMethod!.name,
                      style: GlobalHelper.getTextTheme(context,
                              appTextStyle: AppTextStyle.BODY_SMALL)
                          ?.copyWith(
                              color: GlobalHelper.getColorSchema(context)
                                  .secondary)),
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 1,
                          color:
                              GlobalHelper.getColorSchema(context).secondary),
                      borderRadius: BorderRadius.circular(5)))
            ],
          )
        ]));
  }

  _onPressAddOrder(BuildContext context) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => InputOrderScreen()));
    notifier.init();
  }
}
